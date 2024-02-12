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

    attr_reader :invoice, :order, :locale

    def self.render(invoice, locale:, &)
      new(invoice, locale:, &).render
    end

    def initialize(invoice, locale:, &)
      @invoice = invoice
      @order = invoice.order
      @locale = locale

      update(&)
    end

    def t(key, **options) = I18n.t "invoicing.#{key}", **options.merge(locale:)
  end

  def generate(invoice, locale:)
    Template.render invoice, locale: do
      font_families.update "Inter" => INTER_FONT_FAMILY_DEFINITION

      font "Inter"

      define_grid columns: 6, rows: 4, gutter: 10

      grid([0, 0], [0, 3]).bounding_box do
        text t("receiver"), size: 14, style: :bold
        text order.stripe_object.customer_details.name
        text order.stripe_object.customer_details.address.line1
        text order.stripe_object.customer_details.address.country
        move_down 10
        text "<b>#{t 'company_id'}</b>:", inline_format: true
        text <<~TEXT, inline_format: true
          <b>#{t 'vat_id'}</b>: #{order.stripe_object.customer_details.tax_ids.first.value}
        TEXT
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
        order.tickets.each do |ticket|
          text "#{ticket.ticket_type.name} – #{ticket.name}"
        end
      end

      grid([2, 3], [2, 6]).bounding_box do
        text t("price"), size: 14, style: :bold
        order.tickets.each do |ticket|
          text Currency.format_money(ticket.price, locale:)
        end
      end

      grid([3, 0], [3, 3]).bounding_box do
        text "#{t 'payment_method'}: <b>#{t 'bank_payment'}</b>", inline_format: true
      end

      grid([3, 3], [3, 6]).bounding_box do
        text "#{t 'invoice_total'}: <b>#{Currency.format_money(order.net_amount, locale:)}</b>", inline_format: true
        text "#{t 'vat_percentage'}: <b>20%</b>", inline_format: true
        text "#{t 'calculated_vat'}: <b>#{Currency.format_money(order.tax_amount, locale:)}</b>", inline_format: true
        text "#{t 'total'}: <b>#{Currency.format_money(order.gross_amount, locale:)}</b>", inline_format: true
      end
    end
  end
end
