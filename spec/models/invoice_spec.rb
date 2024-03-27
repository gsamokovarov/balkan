require "rails_helper"

RSpec.case Invoice do
  test "cannot issue invoices for orders before 2024-02-03" do
    order = create :order, completed_at: Time.new(2024, 2, 2)

    assert_raises Precondition::Error do
      Invoice.issue order
    end
  end

  test "cannot issue invoices for orders that did not request it" do
    order = create :order, completed_at: Time.new(2024, 2, 4), issue_invoice: false

    assert_raises Precondition::Error do
      Invoice.issue order
    end
  end

  test "cannot issue invoices for orders with existing invoice" do
    order = create :order, completed_at: Time.current, issue_invoice: true

    Invoice.issue order

    assert_raises Precondition::Error do
      Invoice.issue order
    end
  end

  test "invoice number start with the initial sequence number" do
    order = create :order, completed_at: Time.current, issue_invoice: true

    invoice = Invoice.issue order

    assert_eq invoice.number, 10_001_049
  end

  test "invoice numbers increment from the initial sequence order" do
    event = create :event, :balkan2024

    order1 = create :order, event:, completed_at: Time.current, issue_invoice: true
    order2 = create :order, event:, completed_at: Time.current, issue_invoice: true
    order3 = create :order, event:, completed_at: Time.current, issue_invoice: true

    invoice1 = Invoice.issue order1
    invoice2 = Invoice.issue order2
    invoice3 = Invoice.issue order3

    assert_eq invoice1.number, 10_001_049
    assert_eq invoice2.number, 10_001_050
    assert_eq invoice3.number, 10_001_051
  end

  test "invoice customer details from Stripe can lack tax ID" do
    order = create :order, stripe_checkout_session_uid: "test",
                           stripe_checkout_session: {
                             id: "test",
                             customer_details: {
                               name: "Test",
                               email: "test@example.com",
                               address: { line1: "Test", city: "Test", postal_code: "1234", country: "BG" },
                               tax_ids: []
                             },
                             total_details: { amount_discount: 0, amount_shipping: 0, amount_tax: 0 },
                             amount_total: 30_000,
                           },
                           issue_invoice: true,
                           completed_at: Time.current

    invoice = Invoice.issue order

    assert_eq invoice.customer_details(locale: :en).vat_id, nil
  end

  test "invoice customer details from manually created invoices" do
    order = create :order, stripe_checkout_session_uid: "test",
                           stripe_checkout_session: {
                             id: "test",
                             total_details: { amount_discount: 0, amount_shipping: 0, amount_tax: 0 },
                             amount_total: 30_000,
                           },
                           issue_invoice: true,
                           completed_at: Time.current

    invoice = Invoice.issue order, customer_name: "Test",
                                   customer_address: "Test",
                                   customer_country: "BG",
                                   customer_vat_id: "BG0123456789"

    customer_details = invoice.customer_details locale: :en

    assert_eq customer_details.name, "Test"
    assert_eq customer_details.address, "Test"
    assert_eq customer_details.country, "Bulgaria"
    assert_eq customer_details.vat_id, "BG0123456789"
  end

  test "English document smoke test" do
    invoice = create_invoice_for_document_generation(
      name: "Test",
      email: "test@example.com",
      address: "Test",
      country: "BG",
      amount: "300".to_d,
      ticket_count: 3
    )

    pdf = invoice.document(locale: "en")

    assert_pdf_content pdf,
                       "Supplier NEUVENTS LTD",
                       "Invoice total: € 250.00",
                       "VAT 20%: € 50.00",
                       "Total: € 300.00"
  end

  test "Bulgarian document smoke test" do
    invoice = create_invoice_for_document_generation(
      name: "Test",
      email: "test@example.com",
      address: "Test",
      country: "BG",
      amount: "300".to_d,
      ticket_count: 3
    )

    pdf = invoice.document(locale: "bg")

    assert_pdf_content pdf,
                       "Доставчик НОЙВЕНТС ООД",
                       "Сума по фактура : 488.96 лв .",
                       "ДДС 20%: 97.79 лв .",
                       "Всичко : 586.75 лв ."
  end

  test "Svetlio as МОЛ in documents before 2024-03-12" do
    invoice = create_invoice_for_document_generation(
      name: "Test",
      email: "test@example.com",
      address: "Test",
      country: "BG",
      amount: "300".to_d,
      ticket_count: 3,
      created_at: DateTime.new(2024, 3, 11)
    )

    en = invoice.document(locale: "en")
    bg = invoice.document(locale: "bg")

    assert_pdf_content en, "Svetlozar Mihaylov"
    assert_pdf_content bg, "Светлозар Михайлов"
  end

  test "Genadi as МОЛ in documents after 2024-03-12" do
    invoice = create_invoice_for_document_generation(
      name: "Test",
      email: "test@example.com",
      address: "Test",
      country: "BG",
      amount: "300".to_d,
      ticket_count: 3,
      created_at: DateTime.new(2024, 3, 13)
    )

    en = invoice.document(locale: "en")
    bg = invoice.document(locale: "bg")

    assert_pdf_content en, "Genadi Samokovarov"
    assert_pdf_content bg, "Генади Самоковаров"
  end

  def create_invoice_for_document_generation(
    name:,
    email:,
    address:,
    country:,
    amount:,
    ticket_count:,
    tax_id: nil,
    created_at: nil
  )
    event = create :event, :balkan2024
    order = create :order, event:,
                           email:,
                           amount:,
                           stripe_checkout_session_uid: "test",
                           stripe_checkout_session: {
                             id: "test",
                             customer_details: {
                               name:,
                               email:,
                               address: { line1: address, country: },
                               tax_ids: Array(tax_id)
                             },
                             total_details: { amount_discount: 0, amount_shipping: 0, amount_tax: 0 },
                             amount_total: amount * 1000,
                           },
                           issue_invoice: true,
                           completed_at: Time.current
    ticket_type = create :ticket_type, event:, enabled: true
    create_list :ticket, ticket_count, :genadi, order:, ticket_type:, price: amount / ticket_count

    invoice = Invoice.issue(order)
    invoice.created_at = created_at if created_at
    invoice
  end

  def assert_pdf_content(pdf, *contents)
    text_analysis = PDF::Inspector::Text.analyze pdf
    text_content = text_analysis.strings.map(&:strip).join " "

    contents.each do |content|
      assert_include? text_content, content
    end
  end
end
