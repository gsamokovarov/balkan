class Admin::FormBuilder < ActionView::Helpers::FormBuilder
  FIELD_CLASSES = {
    base: "block w-full rounded-md border-0 py-1.5 shadow-sm ring-1 ring-inset focus:ring-2 focus:ring-inset sm:text-sm sm:leading-6",
    error: "text-red-900 ring-red-300 placeholder:text-red-300 focus:ring-red-500",
    valid: "text-gray-900 ring-gray-300 placeholder:text-gray-400 focus:ring-indigo-600"
  }

  def text_input(method, **options)
    classes = [
      FIELD_CLASSES[:base],
      object.errors[method].any? && FIELD_CLASSES[:error],
      object.errors[method].none? && FIELD_CLASSES[:valid]
    ]

    input_for method do
      @template.concat text_field(method, class: classes, **options)
    end
  end

  def text_area_input(method, **options)
    classes = [
      FIELD_CLASSES[:base],
      object.errors[method].any? && FIELD_CLASSES[:error],
      object.errors[method].none? && FIELD_CLASSES[:valid]
    ]

    input_for method do
      @template.concat text_area(method, class: classes, **options)
    end
  end

  def file_input(method, **)
    field_classes = [
      "block w-full rounded-md p-2 text-sm text-gray-500 shadow-sm ring-1 ring-inset ring-gray-300",
      "focus:ring-indigo-600"
    ]

    image_preview_classes = [
      "w-full mb-2 aspect-square object-cover rounded-md border-1 border-gray-300"
    ]

    input_for method do
      attachment = object.public_send method
      if attachment.attached?
        @template.concat @template.image_tag(attachment, class: image_preview_classes)
      end
      @template.concat file_field(method, class: field_classes, **)
    end
  end

  def submit(value = nil, **)
    value ||= object.persisted? ? "Update" : "Save"
    classes = [
      "inline-block rounded-md px-3 py-2 w-full text-center text-sm font-semibold shadow-sm",
      "focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2",
      "bg-indigo-600 text-white hover:bg-indigo-500 focus-visible:outline-indigo-600 ring-indigo-300"
    ]

    @template.tag.button(value, class: classes, **)
  end

  private

  def input_for(method, &block)
    @template.tag.div class: "space-y-6" do
      @template.concat label(method, class: "block text-sm font-medium leading-6 text-gray-900")
      @template.concat @template.tag.div(&block)
      if object.errors[method].any?
        @template.concat @template.tag.p object.errors[method].first, class: "mt-2 text-sm text-red-600"
      end
    end
  end
end
