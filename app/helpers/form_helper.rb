module FormHelper
  class Builder < ActionView::Helpers::FormBuilder
    FIELD_CLASSES = [
      "w-full border-2 rounded-md border-neutral-600 px-4 py-2 text-black text-ellipsis",
      "focus:ring-0 focus:border-neutral-600 focus:outline-banitsa-600",
    ]

    CHECKBOX_CLASSES = [
      "w-5 h-5 text-banitsa-600 border-neutral-600 rounded-sm",
      "focus:border-black focus:outline-banitsa-600",
    ]

    def text_input(method, label: method, required: false, **)
      input_for method, label:, required: do
        text_field method, class: field_classes, **
      end
    end

    def email_input(method, label: method, required: false, **)
      input_for method, label:, required: do
        email_field method, class: field_classes, **
      end
    end

    def number_input(method, label: method, required: false, **)
      input_for method, label:, required: do
        number_field method, class: field_classes, **
      end
    end

    def select_input(method, choices, label: method, required: false, **options)
      input_for method, label:, required: do
        select method, choices, options, class: field_classes
      end
    end

    def check_box_input(method, label: method, **)
      @template.tag.div class: "flex gap-6" do
        @template.tag.label class: "flex flex-col gap-3 cursor-pointer" do
          @template.tag.span(label, class: "text-xl") + check_box(method, { class: CHECKBOX_CLASSES }, **)
        end
      end
    end

    def captcha = @template.h_captcha

    private

    def input_for(method, label: method, required: false, &block)
      @template.tag.label label, class: "flex flex-col gap-3 sm:max-w-sm" do
        label_text = "#{label.to_s.humanize}#{required ? ' *' : ''}"
        @template.tag.span(label_text, class: "text-xl") +
          @template.capture(&block)
      end
    end

    def field_classes(*) = [*FIELD_CLASSES, *]
  end
end
