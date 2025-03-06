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

    def text_input(method, label: method, required: false, **, &addendum)
      input_for method, label:, required:, addendum: do
        text_field method, class: field_classes, required:, **
      end
    end

    def email_input(method, label: method, required: false, **, &addendum)
      input_for method, label:, required:, addendum: do
        email_field method, class: field_classes, required:, **
      end
    end

    def number_input(method, label: method, required: false, **, &addendum)
      input_for method, label:, required:, addendum: do
        number_field method, class: field_classes, required:, **
      end
    end

    def select_input(method, choices, label: method, required: false, **options, &addendum)
      input_for method, label:, required:, addendum: do
        select method, choices, options, required:, class: field_classes
      end
    end

    def check_box_input(method, label: method, required: false, **, &addendum)
      input_for method, label:, required:, addendum:, class: "cursor-pointer" do
        check_box method, { required:, class: CHECKBOX_CLASSES }, **
      end
    end

    def submit(value = nil, **, &)
      button value, type: "submit", class: "btn-primary w-fit", &
    end

    def captcha = @template.h_captcha

    private

    def input_for(method, label: method, required: false, addendum: nil, class: nil, &)
      @template.tag.label label, class: ["flex flex-col space-y-3 sm:max-w-sm", binding.local_variable_get(:class)] do
        @template.concat @template.tag.span("#{label.to_s.humanize}#{' *' if required}", class: "text-xl")
        @template.concat @template.tag.div(&)
        @template.concat @template.tag.div(&addendum) if addendum
      end
    end

    def field_classes(*) = [*FIELD_CLASSES, *]
  end
end
