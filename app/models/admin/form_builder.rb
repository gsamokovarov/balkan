class Admin::FormBuilder < ActionView::Helpers::FormBuilder
  FIELD_CLASSES = {
    base: [
      "block w-full rounded-md border-0 py-1.5 shadow-sm ring-1 ring-inset focus:ring-2 focus:ring-inset",
      "sm:text-sm sm:leading-6"
    ],
    error: "text-red-900 ring-red-300 placeholder:text-red-300 focus:ring-red-500",
    valid: "text-gray-900 ring-gray-300 placeholder:text-gray-400 focus:ring-indigo-600"
  }

  def check_box_input(method, **, &addendum)
    field_classes = [
      "rounded-md border-0 p-3 text-indigo-600 shadow-sm ring-1 ring-inset focus:ring-2 focus:ring-inset",
      "sm:text-sm sm:leading-6",
      object.errors[method].any? && FIELD_CLASSES[:error],
      object.errors[method].none? && FIELD_CLASSES[:valid]
    ]

    input_for method, addendum: do
      @template.concat check_box(method, class: field_classes, **)
    end
  end

  def email_input(method, **, &addendum)
    input_for method, addendum: do
      @template.concat email_field(method, class: field_classes(method), **)
    end
  end

  def number_input(method, **, &addendum)
    input_for method, addendum: do
      @template.concat number_field(method, class: field_classes(method), **)
    end
  end

  def text_input(method, **, &addendum)
    input_for method, addendum: do
      @template.concat text_field(method, class: field_classes(method), **)
    end
  end

  def text_area_input(method, **, &addendum)
    input_for method, addendum: do
      @template.concat text_area(method, class: field_classes(method), rows: 8, **)
    end
  end

  def password_input(method, **, &addendum)
    input_for method, addendum: do
      @template.concat password_field(method, class: field_classes(method), **)
    end
  end

  def datetime_input(method, **, &addendum)
    input_for method, addendum: do
      @template.concat datetime_field(method, class: field_classes(method), **)
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
    input_for method, error_method:, addendum: do
      @template.concat select(method, choices, options, class: field_classes(method), **html_options)
    end
  end

  def enum_input(method, choices, options = {}, html_options = {}, &addendum)
    enum_choices = choices.map { |choice,| [choice.humanize, choice] }

    input_for method, addendum: do
      @template.concat select(method, enum_choices, options, class: field_classes(method), **html_options)
    end
  end

  def file_input(method, **, &addendum)
    file_classes = [
      "block w-full rounded-md p-2 text-sm text-gray-500 shadow-sm ring-1 ring-inset ring-gray-300",
      "focus:ring-indigo-600"
    ]

    image_preview_classes = [
      "w-full mb-2 aspect-square object-scale-down rounded-md border-1 border-gray-300"
    ]

    input_for method, addendum: do
      attachment = object.public_send method
      if attachment.attached?
        @template.concat @template.image_tag(attachment, class: image_preview_classes)
      end
      @template.concat file_field(method, class: file_classes, **)
    end
  end

  def submit(value = nil, **)
    value ||= object.persisted? ? "Update" : "Save"

    @template.admin_button(:primary, type: :submit) { value }
  end

  private

  def input_for(method, error_method: method, addendum: nil, &block)
    @template.tag.div do
      @template.concat label(method, class: "block text-sm font-medium leading-6 text-gray-900")
      @template.concat @template.tag.div(class: "mt-2", &block)
      if object.errors[error_method].any?
        @template.concat @template.tag.p object.errors[error_method].first, class: "mt-2 text-sm text-red-600"
      end
      @template.concat @template.tag.div(class: "mt-2", &addendum) if addendum
    end
  end

  def field_classes(method, *)
    [
      *FIELD_CLASSES[:base],
      object.errors[method].any? && FIELD_CLASSES[:error],
      object.errors[method].none? && FIELD_CLASSES[:valid],
      *
    ]
  end
end
