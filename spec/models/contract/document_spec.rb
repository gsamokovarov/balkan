require "rails_helper"

RSpec.case Contract::Document do
  test "generates a valid PDF" do
    contract = create :contract

    pdf = contract.document

    assert_kind_of String, pdf
    assert pdf.start_with?("%PDF")
  end

  test "renders event name from liquid context" do
    contract = create :contract

    pdf = contract.document

    assert_pdf_content pdf, "Balkan Ruby 2025"
  end

  test "renders company name" do
    contract = create :contract, company_name: "AppSignal B.V."

    pdf = contract.document

    assert_pdf_content pdf, "AppSignal B.V."
  end

  test "renders price" do
    contract = create :contract, price: 2500

    pdf = contract.document

    assert_pdf_content pdf, "2500.00"
  end

  test "renders headings from markdown" do
    event = create :event, :balkan2025
    template = create :contract_template, event:, content: <<~MARKDOWN
      # Main Title

      ## Section One

      Body text here.
    MARKDOWN
    contract = create :contract, event:, contract_template: template

    pdf = contract.document

    assert_pdf_content pdf, "Main Title", "Section One", "Body text here."
  end

  test "renders bold text" do
    event = create :event, :balkan2025
    template = create :contract_template, event:, content: <<~MARKDOWN
      This is **important** text.
    MARKDOWN
    contract = create :contract, event:, contract_template: template

    pdf = contract.document

    assert_pdf_content pdf, "important"
  end

  test "renders bullet lists" do
    event = create :event, :balkan2025
    template = create :contract_template, event:, content: <<~MARKDOWN
      - First item
      - Second item
      - Third item
    MARKDOWN
    contract = create :contract, event:, contract_template: template

    pdf = contract.document

    assert_pdf_content pdf, "First item", "Second item", "Third item"
  end

  test "renders numbered lists" do
    event = create :event, :balkan2025
    template = create :contract_template, event:, content: <<~MARKDOWN
      1. Step one
      2. Step two
      3. Step three
    MARKDOWN
    contract = create :contract, event:, contract_template: template

    pdf = contract.document

    assert_pdf_content pdf, "Step one", "Step two", "Step three"
  end

  test "renders perks from contract" do
    event = create :event, :balkan2025
    template = create :contract_template, event:, content: <<~MARKDOWN
      ## Perks

      {{ perks }}
    MARKDOWN
    contract = create :contract, event:, contract_template: template, perks: <<~MARKDOWN
      - Logo on website
      - Banner at venue
    MARKDOWN

    pdf = contract.document

    assert_pdf_content pdf, "Perks", "Logo on website", "Banner at venue"
  end

  test "renders issuer details" do
    event = create :event, :balkan2025
    template = create :contract_template, event:, content: <<~MARKDOWN
      Issuer: {{ issuer_company_name }}, {{ issuer_ceo }}
    MARKDOWN
    contract = create :contract, event:, contract_template: template

    pdf = contract.document

    assert_pdf_content pdf, "NEUVENTS LTD", "Genadi Samokovarov"
  end

  test "renders agreement date in DD.MM.YYYY format" do
    event = create :event, :balkan2025
    template = create :contract_template, event:, content: <<~MARKDOWN
      Date: {{ agreement_date }}
    MARKDOWN
    contract = create :contract, event:, contract_template: template, agreement_date: Date.new(2026, 2, 11)

    pdf = contract.document

    assert_pdf_content pdf, "11.02.2026"
  end

  test "renders VAT calculations" do
    event = create :event, :balkan2025
    template = create :contract_template, event:, content: <<~MARKDOWN
      Net: {{ price }} / VAT: {{ vat_amount }} / Total: {{ price_with_vat }}
    MARKDOWN
    contract = create :contract, event:, contract_template: template, price: 1000

    pdf = contract.document

    assert_pdf_content pdf, "1000.00", "200.00", "1200.00"
  end

  test "produces a single-page PDF for short content" do
    contract = create :contract

    pdf = contract.document
    page_count = PDF::Inspector::Page.analyze(pdf).pages.size

    assert_eq page_count, 1
  end
end
