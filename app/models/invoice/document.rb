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
        @tax = 0
        @gross = @net
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

    attr_reader :invoice, :invoice_amount, :customer_details, :line_items

    def self.render(invoice, locale:, &)
      new(invoice, locale:, &).render
    end

    def initialize(invoice, locale:, &)
      @locale = locale
      @invoice = invoice
      @invoice_amount = Amount.new invoice.total_amount, locale:, includes_vat: invoice.includes_vat
      @customer_details = invoice.customer_details(locale:)
      @line_items = invoice.line_items(locale:)

      update(&)
    end

    def fit_text(string, width: bounds.width)
      box = Prawn::Text::Box.new string, document:, width:, at: [bounds.left, cursor], overflow: :shrink_to_fit
      box.render

      move_down box.height
    end

    private

    def line_item_amount(price) = Amount.new(price, locale: @locale, includes_vat: invoice.includes_vat?).net_format
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

      grid([0, 0], [0, 2]).bounding_box do
        text t("receiver"), size: 14, style: :bold
        fit_text customer_details.name.to_s
        fit_text customer_details.address.to_s
        fit_text customer_details.country.to_s
        move_down 10
        text "<b>#{t 'company_id'}</b>: #{invoice.receiver_company_idx}", inline_format: true
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
        text "<b>#{t 'vat_id'}</b>: #{t 'neuvents.vat_id'}", inline_format: true
        text "<b>#{t 'ceo'}</b>: #{t(genadi_ceo? ? 'neuvents.genadi_ceo' : 'neuvents.svetli_ceo')}", inline_format: true
      end

      grid([1, 0], [1, 3]).bounding_box do
        text t("original"), size: 22, style: :bold
      end

      grid([1, 3], [1, 6]).bounding_box do
        text invoice.credit_note? ? t("credit_note") : t("invoice"), size: 22, style: :bold
        text "<b>#{t 'number'}</b>: #{invoice.prefixed_number}", inline_format: true
        text "<b>#{t 'date_of_issue'}</b>: #{(invoice.issue_date || invoice.created_at.to_date).iso8601}", inline_format: true
        text "<b>#{t 'date_of_tax_event'}</b>: #{(invoice.issue_date || invoice.created_at.to_date).iso8601}", inline_format: true
        text "<b>#{t 'for_invoice'}</b>: #{invoice.refunded_invoice.prefixed_number}", inline_format: true if invoice.credit_note?
      end

      grid([2, 0], [2, 4]).bounding_box do
        text t("items"), size: 14, style: :bold
        line_items.each do |item|
          fit_text item.description.to_s
        end
      end

      grid([2, 4], [2, 6]).bounding_box do
        text t("price"), size: 14, style: :bold
        line_items.each do |item|
          text line_item_amount(item.price)
        end
      end

      grid([3, 0], [3, 3]).bounding_box do
        text "<b>#{t 'payment_method'}</b>", inline_format: true
        fit_text invoice.payment_method.presence || t("bank_payment")
      end

      grid([3, 3], [3, 6]).bounding_box do
        vat_label = invoice.includes_vat? ? t("vat") : t("vat_exempt")
        text "#{t 'invoice_total'}: <b>#{invoice_amount.net_format}</b>", inline_format: true
        text "#{vat_label}: <b>#{invoice_amount.tax_format}</b>", inline_format: true
        text "#{t 'total'}: <b>#{invoice_amount.gross_format}</b>", inline_format: true

        if locale.to_sym == :bg
          text "#{t 'total_eur'}: <b>#{invoice_amount.to_eur.gross_format}</b>", inline_format: true
        end
      end
    end
  end
end
