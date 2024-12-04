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
    primary: "bg-indigo-600 text-white ring-indigo-300 hover:bg-indigo-500 focus-visible:outline-indigo-600",
    secondary: "bg-indigo-600 text-gray-900 ring-gray-300 hover:bg-gray-50 focus-visible:outline-indigo-gray-600"
  }

  def admin_button(variant, link: false, **options, &)
    classes = [
      "inline-block rounded-md px-3 py-2 text-center text-sm font-semibold shadow-sm",
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
      links.each_with_index do |link, index|
        classes = [
          index.zero? && "rounded-l-md",
          index.positive? && "-ml-px",
          index == links.size - 1 && "rounded-r-md",
          "relative inline-flex items-center bg-white px-3 py-2 text-sm font-semibold text-gray-900",
          "ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:z-10"
        ]
        concat tag.a(href: link[:href], class: classes) { link[:name] }
      end
    end
  end

  def admin_find_current_nav_link(nav_links)
    nav_links.each do |link|
      if nested_nav_links = link[:items]
        nested_link = admin_find_current_nav_link nested_nav_links
        return nested_link if nested_link
      elsif link[:path]
        return link if current_page? link[:path]
      end
    end

    nil
  end

  def admin_form(object, **options, &)
    options[:html] = { class: "space-y-6", "data-turbo": false, **(options[:html] || {}) }

    tag.div class: "sm:max-w-sm" do
      form_with model: object, builder: Admin::FormBuilder, **options, &
    end
  end

  def admin_table(objects, &)
    render "admin/application/table", objects:, table_def: Admin::TableDefinition.new(self, &)
  end

  def admin_paginate(scope)
    render "admin/application/pagination", scope:, current_page: [params[:page].to_i, 1].max
  end
end
