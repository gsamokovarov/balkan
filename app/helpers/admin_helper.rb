module AdminHelper
  ADMIN_BADGE_TYPES = {
    primary: "ring-gray-600/20 bg-gray-50 text-gray-700",
    success: "ring-green-600/20 bg-green-50 text-green-700",
    danger: "ring-banitsa-500/20 bg-banitsa-50 text-banitsa-500"
  }

  def admin_badge(type, &)
    classes = [
      "inline-flex items-center rounded-md px-2 py-1 text-xs font-medium ring-1 ring-inset",
      ADMIN_BADGE_TYPES.fetch(type)
    ]

    tag.span(class: classes, &)
  end
end
