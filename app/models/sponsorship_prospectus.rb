module SponsorshipProspectus
  extend self

  INTER_FONT_FAMILY_DEFINITION = {
    normal: Rails.root.join("app/assets/fonts/Inter-Regular.ttf"),
    italic: Rails.root.join("app/assets/fonts/Inter-Italic.ttf"),
    bold: Rails.root.join("app/assets/fonts/Inter-Bold.ttf"),
    bold_italic: Rails.root.join("app/assets/fonts/Inter-BoldItalic.ttf"),
  }

  class Template
    include Prawn::View
    include MarkdownHelper

    attr_reader :event

    def self.render(event, &) = new(event, &).render

    def initialize(event, &)
      @event = event
      @sanitizer = Rails::HTML::FullSanitizer.new
      update(&)
    end
  end

  def generate(event)
    Template.render event do
      font_families.update "Inter" => INTER_FONT_FAMILY_DEFINITION

      font "Inter"

      margin = 50

      bounding_box [margin, bounds.top - margin], width: bounds.width - (margin * 2), height: bounds.height - (margin * 2) do
        text event.name, size: 28, style: :bold, align: :center
        move_down 20

        text "SPONSORSHIP PROSPECTUS", size: 22, style: :bold, align: :center
        move_down 40

        if event.title.present?
          text @sanitizer.sanitize(event.title), size: 18, align: :center
          move_down 10
        end

        if event.subtitle.present?
          text @sanitizer.sanitize(event.subtitle), size: 16, align: :center, style: :italic
          move_down 20
        end

        date_text = "#{event.start_date.strftime '%B %d'} - #{event.end_date.strftime '%B %d, %Y'}"
        text date_text, size: 16, align: :center
        move_down 10

        if event.venue
          text "#{event.venue.name}, #{event.venue.address}", size: 14, align: :center
          move_down 50
        else
          move_down 60
        end

        if event.description.present?
          text @sanitizer.sanitize(event.description), size: 14, align: :center
          move_down 50
        end

        text "For sponsorship inquiries, contact:", size: 14, align: :center
        move_down 10
        text event.contact_email || "hi@balkanruby.com", size: 14, align: :center, style: :bold
      end

      start_new_page

      text "Sponsorship Packages", size: 24, style: :bold
      move_down 20

      text "By sponsoring #{event.name}, you are helping us make a great event while promoting your brand to the passionate Ruby developers in Bulgaria, the Balkans, and beyond!", size: 12
      move_down 30

      event.sponsorship_packages.includes(:variants).each do |package|
        text package.name, size: 18, style: :bold
        move_down 5

        if package.description.present?
          text render_plain(package.description), size: 12
          move_down 10
        end

        package.variants.each do |variant|
          quantity =
            if variant.limited?
              variant.available? ? "(#{variant.spots_remaining} available)" : "<b>Sold out</b>"
            end

          text "• #{variant.name}: €#{variant.price} #{quantity}", size: 12, inline_format: true
        end

        move_down 20
      end

      text "See detailed information about each package on the following pages.", size: 12, style: :italic

      event.sponsorship_packages.includes(:variants).each do |package|
        start_new_page

        text package.name, size: 24, style: :bold
        move_down 20

        table_data = [["Name", "Price", "What's Included", "Availability"]] +
                     package.variants.map do |variant|
                       quantity =
                         if variant.limited?
                           variant.available? ? "#{variant.spots_remaining} available" : "Sold out"
                         else
                           "Unlimited"
                         end

                       [variant.name, "€#{variant.price}", render_plain(variant.perks), quantity]
                     end

        table table_data, width: bounds.width, column_widths: [0.25, 0.20, 0.40, 0.15].map { bounds.width * it } do
          row(0).font_style = :bold
          row(0).background_color = "F0F0F0"
          cells.padding = 10
          cells.borders = [:bottom]
          cells.border_color = "DDDDDD"
          row(0).borders = [:top, :bottom]
          row(0).border_color = "000000"

          column(0).font_style = :bold
          column(2).size = 10
        end
      end

      start_new_page

      text "Frequently Asked Questions", size: 24, style: :bold
      move_down 20

      [
        {
          q: "Do I have to provide the banners and roll-up posters?",
          a: "If you have existing printed materials, feel free to bring them along. Otherwise, our team will be handling everything regarding the banner material (printing, setup). Of course, we expect you to provide for the artwork (logos, graphics, etc.) that may be needed. The cost of the banners is included in the package price.",
        },
        {
          q: "Do I have to provide my own stand for the sponsors hall?",
          a: "The exhibit space is a large table (1×2m), provided by us.",
        },
        {
          q: "Do the prices include VAT?",
          a: "The prices do not include VAT, which will be added where applicable.",
        },
        {
          q: "Do you have any other sponsorship options?",
          a: "We are open to discuss other opportunities and bespoke packages to ensure you get the best out of your investment.",
        },
      ].each do |faq|
        text faq[:q], size: 14, style: :bold
        move_down 5
        text faq[:a], size: 12
        move_down 15
      end

      bounding_box [bounds.left, 30], width: bounds.width, height: 30 do
        number_pages "Page <page> of <total>", size: 10
      end
    end
  end
end
