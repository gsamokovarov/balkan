module Invoice::PdfDocument
  extend self

  INTER_FONT_FAMILY_DEFINITION = {
    normal: Rails.root.join("app/assets/fonts/Inter-Regular.ttf"),
    italic: Rails.root.join("app/assets/fonts/Inter-Italic.ttf"),
    bold: Rails.root.join("app/assets/fonts/Inter-Bold.ttf"),
    bold_italic: Rails.root.join("app/assets/fonts/Inter-BoldItalic.ttf")
  }

  class Template
    include Prawn::View

    attr_reader :invoice, :order, :invoice_amount, :invoice_customer

    def self.render(invoice, locale:, &)
      new(invoice, locale:, &).render
    end

    def initialize(invoice, locale:, &)
      @invoice = invoice
      @locale = locale
      @invoice_amount = invoice.amount(locale:)
      @invoice_customer = invoice.customer(locale:)
      @order = invoice.order

      update(&)
    end

    def t(key, **options) = I18n.t "invoicing.#{key}", **options.merge(locale: @locale)
  end

  def generate(invoice, locale:)
    Template.render invoice, locale: do
      font_families.update "Inter" => INTER_FONT_FAMILY_DEFINITION

      font "Inter"

      define_grid columns: 6, rows: 4, gutter: 10

      grid([0, 0], [0, 3]).bounding_box do
        text t("receiver"), size: 14, style: :bold
        text invoice_customer.name
        text invoice_customer.address
        text invoice_customer.country
        move_down 10
        text "<b>#{t 'company_id'}</b>:", inline_format: true
        text "<b>#{t 'vat_id'}</b>: #{invoice_customer.vat_id}", inline_format: true
        text "<b>#{t 'ceo'}</b>:", inline_format: true
      end

      grid([0, 3], [0, 6]).bounding_box do
        text t("supplier"), size: 14, style: :bold
        text t("neuvents.company_name")
        text t("neuvents.address")
        text t("neuvents.country")
        move_down 10
        text "<b>#{t 'company_id'}</b>: #{t 'neuvents.company_id'}", inline_format: true
        text <<~TEXT, inline_format: true
          <b>#{t 'vat_id'}</b>: #{t 'neuvents.vat_id'}
        TEXT
        text "<b>#{t 'ceo'}</b>: #{t 'neuvents.ceo'}", inline_format: true
      end

      grid([1, 0], [1, 3]).bounding_box do
        text t("invoice"), size: 22, style: :bold
        text "<b>#{t 'number'}</b>: #{format '%010d', invoice.number}", inline_format: true
        text "<b>#{t 'date_of_issue'}</b>: #{invoice.created_at.to_date.iso8601}", inline_format: true
        text "<b>#{t 'date_of_tax_event'}</b>: #{order.completed_at.to_date.iso8601}", inline_format: true
      end

      grid([2, 0], [2, 3]).bounding_box do
        text t("items"), size: 14, style: :bold
        text t("tickets", count: order.tickets.count, type: order.tickets.first.ticket_type.name)
      end

      grid([2, 3], [2, 6]).bounding_box do
        text t("price"), size: 14, style: :bold
        text invoice_amount.net_format
      end

      grid([3, 0], [3, 3]).bounding_box do
        text "#{t 'payment_method'}: <b>#{t 'bank_payment'}</b>", inline_format: true
      end

      grid([3, 3], [3, 6]).bounding_box do
        text "#{t 'invoice_total'}: <b>#{invoice_amount.net_format}</b>", inline_format: true
        text "#{t 'vat'}: <b>#{invoice_amount.tax_format}</b>", inline_format: true
        text "#{t 'total'}: <b>#{invoice_amount.gross_format}</b>", inline_format: true
      end
    end
  end
end
