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
end
