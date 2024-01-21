module AdminHelper
  ADMIN_BADGE_VARIANTS = {
    primary: "ring-gray-600/20 bg-gray-50 text-gray-700",
    success: "ring-green-600/20 bg-green-50 text-green-700",
    danger: "ring-banitsa-500/20 bg-banitsa-50 text-banitsa-500"
  }

  def admin_badge(variant, &)
    classes = [
      "inline-flex items-center rounded-md px-2 py-1 text-xs font-medium ring-1 ring-inset",
      ADMIN_BADGE_VARIANTS.fetch(variant)
    ]

    tag.span(class: classes, &)
  end

  ADMIN_BUTTON_VARIANTS = {
    primary: "bg-indigo-600 text-white hover:bg-indigo-500 focus-visible:outline-indigo-600"
  }

  def admin_button(variant, link: false, **options, &)
    classes = [
      "block rounded-md px-3 py-2 text-center text-sm font-semibold shadow-sm",
      "focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2",
      ADMIN_BUTTON_VARIANTS.fetch(variant),
      options[:class]
    ]

    if link
      tag.a(**options, class: classes, &)
    else
      tag.button(**options, class: classes, &)
    end
  end
end
