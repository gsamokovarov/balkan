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
                               tax_ids: [],
                             },
                             total_details: { amount_discount: 0, amount_shipping: 0, amount_tax: 0 },
                             amount_total: 30_000,
                           },
                           issue_invoice: true,
                           completed_at: Time.current

    invoice = Invoice.issue order

    assert_eq invoice.customer_details(locale: :en).vat_id, nil
  end

  test "invoice customer details from Stripe can address lines" do
    order = create :order, stripe_checkout_session_uid: "test",
                           stripe_checkout_session: {
                             id: "test",
                             customer_details: {
                               name: "Test",
                               email: "test@example.com",
                               address: { line1: nil, city: "Test", postal_code: "1234", country: "BG" },
                               tax_ids: [],
                             },
                             total_details: { amount_discount: 0, amount_shipping: 0, amount_tax: 0 },
                             amount_total: 30_000,
                           },
                           issue_invoice: true,
                           completed_at: Time.current

    invoice = Invoice.issue order

    assert_eq invoice.customer_details(locale: :en).address, "Test 1234"
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
                                   customer_vat_idx: "BG0123456789"

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
      ticket_count: 3,
    )

    pdf = invoice.document locale: "en"

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
      ticket_count: 3,
    )

    pdf = invoice.document locale: "bg"

    assert_pdf_content pdf,
                       "Доставчик НОЙВЕНТС ООД",
                       "Сума по фактура : 488.96 лв .",
                       "ДДС 20%: 97.79 лв .",
                       "Всичко (BGN): 586.75 лв .",
                       "Всичко (EUR): € 300.00"
  end

  test "Svetlio as МОЛ in documents before 2024-03-12" do
    invoice = create_invoice_for_document_generation(
      name: "Test",
      email: "test@example.com",
      address: "Test",
      country: "BG",
      amount: "300".to_d,
      ticket_count: 3,
      created_at: DateTime.new(2024, 3, 11),
    )

    en = invoice.document locale: "en"
    bg = invoice.document locale: "bg"

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
      created_at: DateTime.new(2024, 3, 13),
    )

    en = invoice.document locale: "en"
    bg = invoice.document locale: "bg"

    assert_pdf_content en, "Genadi Samokovarov"
    assert_pdf_content bg, "Генади Самоковаров"
  end

  test "manual? returns true when order is nil" do
    invoice_sequence = create :invoice_sequence
    invoice = Invoice.new invoice_sequence:, number: 1

    assert_eq invoice.manual?, true
  end

  test "manual? returns false when order is present" do
    order = create :order, completed_at: Time.current, issue_invoice: true
    invoice = Invoice.issue order

    assert_eq invoice.manual?, false
  end

  test "credit_note? returns true when refunded_invoice is present" do
    invoice_sequence = create :invoice_sequence
    original = Invoice.create! invoice_sequence:, number: 1
    credit_note = Invoice.new invoice_sequence:, number: 2, refunded_invoice: original

    assert_eq credit_note.credit_note?, true
    assert_eq credit_note.invoice?, false
  end

  test "credit_note? returns false when refunded_invoice is nil" do
    invoice_sequence = create :invoice_sequence
    invoice = Invoice.new invoice_sequence:, number: 1

    assert_eq invoice.credit_note?, false
    assert_eq invoice.invoice?, true
  end

  test "total_amount sums invoice items" do
    invoice_sequence = create :invoice_sequence
    invoice = Invoice.create! invoice_sequence:, number: 1
    invoice.items.create! description_en: "Item 1", description_bg: "Артикул 1", unit_price: 100
    invoice.items.create! description_en: "Item 2", description_bg: "Артикул 2", unit_price: 50

    assert_eq invoice.total_amount, 150
  end

  test "total_amount returns zero when no items" do
    invoice_sequence = create :invoice_sequence
    invoice = Invoice.create! invoice_sequence:, number: 1

    assert_eq invoice.total_amount, 0
  end

  test "total_amount sums unsaved in-memory items" do
    invoice_sequence = create :invoice_sequence
    invoice = Invoice.new invoice_sequence:, number: 1
    invoice.items.build description_en: "Item 1", description_bg: "Артикул 1", unit_price: 100
    invoice.items.build description_en: "Item 2", description_bg: "Артикул 2", unit_price: 50

    assert_eq invoice.total_amount, 150
  end

  test "manual invoice customer details use invoice fields" do
    invoice_sequence = create :invoice_sequence
    invoice = Invoice.create!(
      invoice_sequence:,
      number: 1,
      customer_name: "Test Company",
      customer_address: "123 Test St",
      customer_country: "BG",
      customer_vat_idx: "BG123456789",
    )

    details = invoice.customer_details locale: :en

    assert_eq details.name, "Test Company"
    assert_eq details.address, "123 Test St"
    assert_eq details.country, "Bulgaria"
    assert_eq details.vat_id, "BG123456789"
  end

  test "manual invoice document generation" do
    invoice_sequence = create :invoice_sequence
    invoice = Invoice.create!(
      invoice_sequence:,
      number: 1,
      issue_date: Date.new(2024, 6, 15),
      tax_event_date: Date.new(2024, 6, 15),
      customer_name: "Test Company",
      customer_address: "123 Test St",
      customer_country: "BG",
      includes_vat: true,
    )
    invoice.items.create! description_en: "Consulting services", description_bg: "Консултантски услуги", unit_price: 500

    pdf = invoice.document locale: :en

    assert_pdf_content pdf,
                       "Test Company",
                       "Invoice",
                       "Consulting services"
  end

  test "manual invoice shows custom payment method in PDF" do
    invoice_sequence = create :invoice_sequence
    invoice = Invoice.create!(
      invoice_sequence:,
      number: 1,
      issue_date: Date.new(2024, 6, 15),
      tax_event_date: Date.new(2024, 6, 15),
      customer_name: "Test Company",
      customer_address: "123 Test St",
      customer_country: "BG",
      includes_vat: true,
      payment_method: "Bank transfer",
    )
    invoice.items.create! description_en: "Consulting", description_bg: "Консултации", unit_price: 100

    pdf = invoice.document locale: :en

    assert_pdf_content pdf, "Payment method", "Bank transfer"
  end

  test "manual invoice without payment method shows default in PDF" do
    invoice_sequence = create :invoice_sequence
    invoice = Invoice.create!(
      invoice_sequence:,
      number: 1,
      issue_date: Date.new(2024, 6, 15),
      tax_event_date: Date.new(2024, 6, 15),
      customer_name: "Test Company",
      customer_address: "123 Test St",
      customer_country: "BG",
      includes_vat: true,
    )
    invoice.items.create! description_en: "Consulting", description_bg: "Консултации", unit_price: 100

    pdf = invoice.document locale: :en

    assert_pdf_content pdf, "Payment method", "Stripe / Credit Card"
  end

  test "credit note document shows Credit Note header" do
    invoice_sequence = create :invoice_sequence
    original = Invoice.create!(
      invoice_sequence:,
      number: 1,
      issue_date: Date.new(2024, 6, 15),
      tax_event_date: Date.new(2024, 6, 15),
      customer_name: "Test Company",
      customer_address: "123 Test St",
      customer_country: "BG",
    )
    original.items.create! description_en: "Original item", description_bg: "Оригинален артикул", unit_price: 100

    credit_note = Invoice.create!(
      invoice_sequence:,
      number: 2,
      issue_date: Date.new(2024, 6, 20),
      tax_event_date: Date.new(2024, 6, 20),
      refunded_invoice: original,
      customer_name: "Test Company",
      customer_address: "123 Test St",
      customer_country: "BG",
    )
    credit_note.items.create!(description_en: "Refund", description_bg: "Възстановяване", unit_price: -100)

    pdf = credit_note.document locale: :en

    assert_pdf_content pdf,
                       "Credit Note",
                       "For invoice : 0000000001"
  end

  test "invoice with includes_vat false shows zero VAT" do
    invoice_sequence = create :invoice_sequence
    invoice = Invoice.create!(
      invoice_sequence:,
      number: 1,
      issue_date: Date.new(2024, 6, 15),
      tax_event_date: Date.new(2024, 6, 15),
      customer_name: "Test",
      customer_address: "Test",
      customer_country: "BG",
      includes_vat: false,
    )
    invoice.items.create! description_en: "Net item", description_bg: "Нето артикул", unit_price: 100

    pdf = invoice.document locale: :en

    assert_pdf_content pdf,
                       "Invoice total: € 100.00",
                       "VAT 0%: € 0.00",
                       "Total: € 100.00"
  end

  test "issue_refund creates credit note with correct attributes" do
    ticket_type = create :ticket_type, :enabled
    checkout_session = Stripe::Checkout::Session.construct_from(
      id: "test",
      customer_details: {
        name: "Test Customer",
        email: "test@example.com",
        address: { line1: "123 Test St", city: "Sofia", country: "BG", postal_code: "1000" },
        tax_ids: [type: "bg_vat", value: "BG123456789"],
      },
      total_details: { amount_discount: 0, amount_shipping: 0, amount_tax: 0 },
      amount_total: 15_000,
    )

    order = create :order, stripe_checkout_session_uid: "test", issue_invoice: true,
                           pending_tickets: [{ "name" => "John", "email" => "john@example.com", "price" => 150, "shirt_size" => "L", "ticket_type_id" => ticket_type.id }]
    order.complete! checkout_session

    credit_note_sequence = create :invoice_sequence, name: "Credit Notes", initial_number: 90_000_001

    credit_note = order.invoice.issue_refund 50, invoice_sequence: credit_note_sequence

    assert_eq credit_note.credit_note?, true
    assert_eq credit_note.refunded_invoice, order.invoice
    assert_eq credit_note.number, 90_000_001
    assert_eq credit_note.customer_name, "Test Customer"
    assert_eq credit_note.customer_address, "123 Test St"
    assert_eq credit_note.customer_country, "BG"
    assert_eq credit_note.customer_vat_idx, "BG123456789"
    assert_eq credit_note.receiver_email, "test@example.com"
    assert_eq credit_note.items.first.unit_price, 50
    assert_eq credit_note.items.first.description_en, "Refund for Invoice ##{order.invoice.prefixed_number}"
    assert_eq credit_note.items.first.description_bg, "Възстановяване за фактура ##{order.invoice.prefixed_number}"
  end

  test "issue_refund fails for credit notes" do
    invoice_sequence = create :invoice_sequence
    original = Invoice.create! invoice_sequence:, number: 1
    credit_note = Invoice.create! invoice_sequence:, number: 2, refunded_invoice: original

    assert_raises Precondition::Error do
      credit_note.issue_refund 50, invoice_sequence:
    end
  end

  test "issue_refund fails for manual invoices" do
    invoice_sequence = create :invoice_sequence
    manual_invoice = Invoice.create! invoice_sequence:, number: 1

    assert_raises Precondition::Error do
      manual_invoice.issue_refund 50, invoice_sequence:
    end
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
                               tax_ids: Array(tax_id),
                             },
                             total_details: { amount_discount: 0, amount_shipping: 0, amount_tax: 0 },
                             amount_total: amount * 1000,
                           },
                           issue_invoice: true,
                           completed_at: Time.current
    ticket_type = create :ticket_type, event:, enabled: true
    create_list :ticket, ticket_count, :genadi, order:, ticket_type:, price: amount / ticket_count

    invoice = Invoice.issue order
    invoice.created_at = created_at if created_at
    invoice
  end
end
