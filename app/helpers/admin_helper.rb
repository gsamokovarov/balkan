module AdminHelper
  ADMIN_BADGE_VARIANTS = {
    primary: "ring-gray-600/20 bg-gray-50 text-gray-700",
    success: "ring-green-600/20 bg-green-50 text-green-700",
    warning: "ring-yellow-600/20 bg-yellow-50 text-yellow-800",
    danger: "ring-banitsa-500/20 bg-banitsa-50 text-banitsa-500"
  }

  def admin_badge(variant, content = nil, **options, &)
    classes = [
      "inline-flex items-center rounded-md px-2 py-1 text-xs font-medium ring-1 ring-inset",
      ADMIN_BADGE_VARIANTS.fetch(variant),
      options[:class]
    ]

    tag.span(content, class: classes, **options, &)
  end

  ADMIN_BUTTON_VARIANTS = {
    primary: "bg-indigo-600 text-white hover:bg-indigo-500 focus-visible:outline-indigo-600 ring-indigo-300"
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

  def admin_button_group(*links)
    tag.span class: "isolate inline-flex rounded-md shadow-sm" do
      content = capture { "" }
      links.each_with_index do |link, index|
        classes = [
          index.zero? && "rounded-l-md",
          index.positive? && "-ml-px",
          index == links.size - 1 && "rounded-r-md",
          "relative inline-flex items-center bg-white px-3 py-2 text-sm font-semibold text-gray-900 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:z-10"
        ]
        content <<
          capture do
            tag.a(href: link[:href], class: classes) { link[:name] }
          end
      end
      content
    end
  end
end
