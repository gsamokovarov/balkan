require "rails_helper"

RSpec.case Admin::InvoicesController, type: :request do
  test "preview returns a PDF" do
    create :event, :balkan2025
    sign_in create(:user, name: "Admin", email: "admin@example.com", password: "password")

    post preview_admin_invoices_path, params: { invoice: {
      invoice_sequence_id: create(:invoice_sequence).id,
      issue_date: Date.current,
      tax_event_date: Date.current,
      customer_name: "Test Customer",
      customer_address: "123 Test St",
      customer_country: "BG",
      items_attributes: { "0" => { description_en: "Test Item", description_bg: "Тест", unit_price: "100.00" } },
    } }

    assert_have_http_status response, :ok
    assert_eq response.content_type, "application/pdf"
  end

  test "preview works with empty optional fields" do
    create :event, :balkan2025
    sign_in create(:user, name: "Admin", email: "admin@example.com", password: "password")

    post preview_admin_invoices_path, params: { invoice: {
      invoice_sequence_id: create(:invoice_sequence).id,
      customer_country: "",
    } }

    assert_have_http_status response, :ok
    assert_eq response.content_type, "application/pdf"
  end

  test "preview requires authentication" do
    create :event, :balkan2025

    post preview_admin_invoices_path, params: { invoice: { customer_name: "Test" } }

    assert_have_http_status response, :redirect
  end

  test "refund creates a credit note for manual invoice" do
    create :event, :balkan2025
    sign_in create(:user, name: "Admin", email: "admin@example.com", password: "password")

    invoice_sequence = create :invoice_sequence
    credit_note_sequence = create :invoice_sequence, name: "Credit Notes", initial_number: 90_000_001

    invoice = Invoice.create!(
      invoice_sequence:,
      number: invoice_sequence.next_invoice_number,
      customer_name: "Test Customer",
      customer_address: "123 Test St",
      customer_country: "BG",
      receiver_email: "test@example.com",
    )
    invoice.items.create! description_en: "Service", description_bg: "Услуга", unit_price: 100

    post refund_admin_invoice_path(invoice), params: {
      invoice_sequence_id: credit_note_sequence.id,
      refunded_amount: "100.00",
    }

    assert_have_http_status response, :redirect

    credit_note = invoice.reload.refund
    assert_eq credit_note.present?, true
    assert_eq credit_note.credit_note?, true
    assert_eq credit_note.customer_name, "Test Customer"
    assert_eq credit_note.items.first.unit_price, 100
  end
end
