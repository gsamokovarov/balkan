module Admin::FormHelper
  class Builder < ActionView::Helpers::FormBuilder
    FIELD_CLASSES = {
      base: [
        "block w-full rounded-md border-0 py-1.5 shadow-sm ring-1 ring-inset focus:ring-2 focus:ring-inset",
        "sm:text-sm sm:leading-6",
      ],
      error: "text-red-900 dark:text-red-300 ring-red-300 dark:ring-red-500 placeholder:text-red-300 dark:placeholder:text-red-500 focus:ring-red-500 dark:bg-gray-800",
      valid: "text-gray-900 dark:text-gray-100 ring-gray-300 dark:ring-gray-600 placeholder:text-gray-400 dark:placeholder:text-gray-500 focus:ring-indigo-600 dark:bg-gray-800",
    }

    def check_box_input(method, label: method, checked_value: "1", unchecked_value: "0", **, &addendum)
      field_classes = [
        "rounded-md border-0 p-3 text-indigo-600 shadow-sm ring-1 ring-inset focus:ring-2 focus:ring-inset",
        "sm:text-sm sm:leading-6",
        object_errors(method).any? ? FIELD_CLASSES[:error] : FIELD_CLASSES[:valid],
      ]

      input_for method, label:, addendum: do
        @template.concat check_box(method, { class: field_classes, ** }, checked_value, unchecked_value)
      end
    end

    def email_input(method, label: method, **, &addendum)
      input_for method, label:, addendum: do
        @template.concat email_field(method, class: field_classes(method), **)
      end
    end

    def number_input(method, label: method, **, &addendum)
      input_for method, label:, addendum: do
        @template.concat number_field(method, class: field_classes(method), **)
      end
    end

    def decimal_input(method, label: method, step: "0.01", **, &addendum)
      input_for method, label:, addendum: do
        @template.concat number_field(method, step:, class: field_classes(method), **)
      end
    end

    def text_input(method, label: method, class: nil, **, &addendum)
      input_for method, class:, label:, addendum: do
        @template.concat text_field(method, class: field_classes(method), **)
      end
    end

    def text_area_input(method, label: method, class: nil, **, &addendum)
      input_for method, class:, label:, addendum: do
        @template.concat text_area(method, class: field_classes(method), rows: 8, **)
      end
    end

    def password_input(method, label: method, **, &addendum)
      input_for method, label:, addendum: do
        @template.concat password_field(method, class: field_classes(method), **)
      end
    end

    def date_input(method, label: method, **, &addendum)
      input_for method, label:, addendum: do
        @template.concat date_field(method, class: field_classes(method), **)
      end
    end

    def month_input(method, label: method, **, &addendum)
      input_for method, class:, label:, addendum: do
        @template.concat month_field(method, class: field_classes(method), **)
      end
    end

    def time_input(method, label: method, **, &addendum)
      input_for method, label:, addendum: do
        @template.concat time_field(method, class: field_classes(method), **)
      end
    end

    def readonly_input(method, choices = [], options = {}, html_options = {}, &addendum)
      readonly_classes = field_classes method, "opacity-50 cursor-not-allowed"

      error_method = method.to_s.delete_suffix "_id"
      input_for method, error_method:, addendum: do
        @template.concat select(method, choices, options, class: readonly_classes, disabled: true, **html_options)
      end
    end

    def select_input(method, choices, options = {}, html_options = {}, &addendum)
      error_method = method.to_s.delete_suffix "_id"
      input_for method, error_method:, label: options.delete(:label) || method, addendum: do
        @template.concat select(method, choices, options, class: field_classes(method), **html_options)
      end
    end

    def enum_input(method, choices, options = {}, html_options = {}, &addendum)
      enum_choices = choices.map { |choice,| [choice.humanize, choice] }

      input_for method, label: options.delete(:label) || method, addendum: do
        @template.concat select(method, enum_choices, options, class: field_classes(method), **html_options)
      end
    end

    def radio_button_input(method, value, label: value.to_s.humanize, checked: false, class: nil, **, &addendum)
      field_classes = [
        "h-4 w-4 border-gray-300 dark:border-gray-600 text-indigo-600 focus:ring-indigo-500 dark:bg-gray-800",
        object_errors(method).any? ? FIELD_CLASSES[:error] : FIELD_CLASSES[:valid],
      ]

      @template.tag.div class: ["flex items-center", binding.local_variable_get(:class)] do
        @template.tag.label class: "flex items-center text-sm font-medium text-gray-700 dark:text-gray-300" do
          @template.concat radio_button(method, value, { class: field_classes, checked:, ** })
          @template.concat @template.tag.span(class: "ml-3") { label }
          @template.concat @template.tag.div(&addendum) if addendum
        end
      end
    end

    def file_input(method, label: method, multiple: false, include_hidden: false, **, &addendum)
      file_classes = [
        "block w-full rounded-md p-2 text-sm text-gray-500 dark:text-gray-400 shadow-sm ring-1 ring-inset ring-gray-300 dark:ring-gray-600",
        "focus:ring-indigo-600 dark:bg-gray-800",
      ]

      image_preview_classes = [
        "w-full max-h-64 mb-2 p-2 aspect-auto object-scale-down rounded-md border border-gray-300 dark:border-gray-600",
      ]

      input_for method, label:, addendum: do
        if multiple
          object.public_send(method).each do |attachment|
            @template.concat @template.image_tag(attachment, class: image_preview_classes)
          end
        else
          attachment = object.public_send method
          if attachment.attached?
            @template.concat @template.image_tag(attachment, class: image_preview_classes)
          end
        end
        @template.concat file_field(method, class: file_classes, multiple:, include_hidden:, **)
      end
    end

    def submit(value = nil, **)
      value ||= object&.persisted? ? "Update" : "Save"

      @template.admin_button(:primary, type: :submit, **) { value }
    end

    FIELDSET_CLASSES = "p-4 pt-0 space-y-4 rounded-lg border-2 border-dashed border-gray-300 dark:border-gray-600"
    LEGEND_CLASSES = "text-sm font-medium leading-6 text-gray-500 dark:text-gray-400"

    def fieldset(legend, appendable: false, class: nil, &block)
      options = { class: [FIELDSET_CLASSES, binding.local_variable_get(:class)] }
      options[:data] = { controller: "appendable" } if appendable

      @template.tag.fieldset(**options) do
        @template.concat @template.tag.legend(legend, class: LEGEND_CLASSES)
        @template.concat @template.capture(&block)
      end
    end

    private

    def input_for(method, error_method: method, label: method, addendum: nil, class: nil, &)
      @template.tag.div class: do
        @template.concat label(label, class: "block text-sm font-medium leading-6 text-gray-900 dark:text-gray-100")
        @template.concat @template.tag.div(class: "mt-2", &)
        if object_errors(error_method).any?
          @template.concat @template.tag.p object_errors(error_method).first, class: "mt-2 text-sm text-red-600 dark:text-red-400"
        end
        @template.concat @template.tag.div(class: "mt-2", &addendum) if addendum
      end
    end

    def field_classes(error_method, *)
      [*FIELD_CLASSES[:base], object_errors(error_method).any? ? FIELD_CLASSES[:error] : FIELD_CLASSES[:valid], *]
    end

    def object_errors(error_method) = object.respond_to?(:errors) ? object.errors[error_method] : []
  end
end
