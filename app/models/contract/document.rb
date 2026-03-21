module Contract::Document
  extend self

  INTER_FONT_FAMILY_DEFINITION = Invoice::Document::INTER_FONT_FAMILY_DEFINITION
  NOTO_SANS_JP_FAMILY_DEFINITION = Invoice::Document::NOTO_SANS_JP_FAMILY_DEFINITION

  MARGIN = 50
  FOOTER_HEIGHT = 30

  class Template
    include Prawn::View
    include MarkdownHelper

    attr_reader :contract

    def self.render(...) = new(...).render

    def initialize(contract, &)
      @contract = contract
      update(&)
    end
  end

  def generate(contract)
    Template.render contract do
      font_families.update "Inter" => INTER_FONT_FAMILY_DEFINITION,
                           "NotoSansJP" => NOTO_SANS_JP_FAMILY_DEFINITION

      font "Inter"
      fallback_fonts ["NotoSansJP"]

      bounding_box [MARGIN, bounds.top - MARGIN], width: bounds.width - (MARGIN * 2),
                                                  height: bounds.height - (MARGIN * 2) - FOOTER_HEIGHT do
        MarkdownHelper::Markup.render_pdf contract.rendered_content, document: self
      end

      bounding_box [MARGIN, MARGIN + FOOTER_HEIGHT], width: bounds.width - (MARGIN * 2), height: FOOTER_HEIGHT do
        number_pages "<page>/<total>", size: 10, align: :right
      end
    end
  end
end
