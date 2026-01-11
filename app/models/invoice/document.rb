module Invoice::Document
  extend self

  INTER_FONT_FAMILY_DEFINITION = {
    normal: Rails.root.join("app/assets/fonts/Inter-Regular.ttf"),
    italic: Rails.root.join("app/assets/fonts/Inter-Italic.ttf"),
    bold: Rails.root.join("app/assets/fonts/Inter-Bold.ttf"),
    bold_italic: Rails.root.join("app/assets/fonts/Inter-BoldItalic.ttf"),
  }

  NOTO_SANS_JP_FAMILY_DEFINITION = {
    normal: Rails.root.join("app/assets/fonts/NotoSansJP-Regular.ttf"),
    bold: Rails.root.join("app/assets/fonts/NotoSansJP-Bold.ttf"),
  }

  class Amount
    EUR_TO_BGN_RATE = "1.95583".to_d
    BULGARIAN_VAT = "0.2".to_d

    attr_reader :gross, :net, :tax

    def initialize(amount_in_eur, locale: :en, includes_vat: true)
      @bulgarian = locale.to_sym == :bg
      @includes_vat = includes_vat

      @amount_in_eur = amount_in_eur.to_d
      amount = round(@bulgarian ? eur_to_bgn(@amount_in_eur) : @amount_in_eur)

      if @includes_vat
        @gross = amount
        @net = round @gross / (1 + BULGARIAN_VAT)
        @tax = round @gross - @net
      else
        @net = amount
        @tax = round @net * BULGARIAN_VAT
        @gross = round @net + @tax
      end
    end

    def gross_format = format gross
    def net_format = format net
    def tax_format = format tax

    def to_eur = Amount.new(@amount_in_eur, locale: :en, includes_vat: @includes_vat)

    private

    def round(amount) = amount.round 2, :half_even
    def eur_to_bgn(eur) = eur * EUR_TO_BGN_RATE

    def format(amount)
      if @bulgarian
        Kernel.format "%0.2f лв.", amount
      else
        Kernel.format "€%0.2f", amount
      end
    end
  end

  class Template
    GENADI_AS_CEO_DATE = Date.new 2024, 3, 12

    include Prawn::View

    attr_reader :invoice, :invoice_amount, :customer_details

    def self.render(invoice, locale:, &)
      new(invoice, locale:, &).render
    end

    def initialize(invoice, locale:, &)
      @locale = locale
      @invoice = invoice
      amount = invoice.manual? ? invoice.total_amount : invoice.order.amount
      @invoice_amount = Amount.new(amount, locale:, includes_vat: invoice.includes_vat)
      @customer_details = invoice.customer_details(locale:)

      update(&)
    end

    def fit_text(string, width:)
      box = Prawn::Text::Box.new string,
                                 document:,
                                 width:,
                                 at: [bounds.left, cursor],
                                 overflow: :shrink_to_fit
      box.render
      move_down box.height
    end

    private

    def genadi_ceo? = invoice.created_at.after? GENADI_AS_CEO_DATE

    def t(key, **) = I18n.t("invoicing.#{key}", **, locale: @locale)
  end

  def generate(invoice, locale:)
    Template.render invoice, locale: do
      font_families.update "Inter" => INTER_FONT_FAMILY_DEFINITION,
                           "NotoSansJP" => NOTO_SANS_JP_FAMILY_DEFINITION

      font "Inter"
      fallback_fonts ["NotoSansJP"]

      define_grid columns: 6, rows: 4, gutter: 10

      column = grid [0, 0], [0, 2]
      column.bounding_box do
        text t("receiver"), size: 14, style: :bold
        fit_text customer_details.name.to_s, width: column.width
        fit_text customer_details.address.to_s, width: column.width
        fit_text customer_details.country.to_s, width: column.width
        move_down 10
        text "<b>#{t 'company_id'}</b>: #{invoice.receiver_company_uid}", inline_format: true
        text "<b>#{t 'vat_id'}</b>: #{customer_details.vat_id}", inline_format: true
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
        text "<b>#{t 'ceo'}</b>: #{t(genadi_ceo? ? 'neuvents.genadi_ceo' : 'neuvents.svetli_ceo')}",
             inline_format: true
      end

      grid([1, 0], [1, 3]).bounding_box do
        text t("original"), size: 22, style: :bold
      end

      grid([1, 3], [1, 6]).bounding_box do
        document_type = invoice.credit_note? ? t("credit_note") : t("invoice")
        text document_type, size: 22, style: :bold
        text "<b>#{t 'number'}</b>: #{format '%010d', invoice.number}", inline_format: true
        issue_date = invoice.issue_date || invoice.created_at.to_date
        text "<b>#{t 'date_of_issue'}</b>: #{issue_date.iso8601}", inline_format: true
        tax_event_date = invoice.tax_event_date || invoice.order&.completed_at&.to_date
        text "<b>#{t 'date_of_tax_event'}</b>: #{tax_event_date&.iso8601}", inline_format: true
        if invoice.credit_note?
          text "<b>#{t 'for_invoice'}</b>: #{format '%010d', invoice.refunded_invoice.number}", inline_format: true
        end
      end

      grid([2, 0], [2, 3]).bounding_box do
        text t("items"), size: 14, style: :bold
        if invoice.manual?
          invoice.items.each do |item|
            description = @locale.to_sym == :bg ? item.description_bg : item.description_en
            text description.to_s
          end
        else
          text t("tickets", count: invoice.order.tickets.size, type: invoice.order.tickets.first.ticket_type.name)
        end
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

        if locale.to_sym == :bg
          text "#{t 'total_eur'}: <b>#{invoice_amount.to_eur.gross_format}</b>", inline_format: true
        end
      end
    end
  end
end
