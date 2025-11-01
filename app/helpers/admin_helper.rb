module AdminHelper
  ADMIN_BADGE_VARIANTS = {
    primary: "ring-gray-600/20 dark:ring-gray-400/30 bg-gray-50 dark:bg-gray-700 text-gray-700 dark:text-gray-300",
    success: "ring-green-600/20 dark:ring-green-400/30 bg-green-50 dark:bg-green-900/30 text-green-700 dark:text-green-400",
    warning: "ring-yellow-600/20 dark:ring-yellow-400/30 bg-yellow-50 dark:bg-yellow-900/30 text-yellow-800 dark:text-yellow-400",
    danger: "ring-banitsa-500/20 dark:ring-banitsa-400/30 bg-banitsa-50 dark:bg-banitsa-900/30 text-banitsa-500 dark:text-banitsa-400",
  }

  def admin_badge(variant, content = nil, **options, &)
    classes = [
      "inline-flex items-center rounded-md px-2 py-1 text-xs font-medium ring-1 ring-inset",
      ADMIN_BADGE_VARIANTS.fetch(variant),
      options[:class],
    ]

    tag.span(content, class: classes, **options, &)
  end

  ADMIN_BUTTON_VARIANTS = {
    primary: "bg-indigo-600 text-white hover:bg-indigo-500 focus-visible:outline-indigo-600",
    secondary: "bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 ring-1 ring-gray-300 dark:ring-gray-600 hover:bg-gray-50 dark:hover:bg-gray-600 focus-visible:outline-gray-600",
    danger: "bg-red-600 text-white hover:bg-red-500 focus-visible:outline-red-600",
  }

  ADMIN_BUTTON_SIZES = {
    small: "px-2 py-1 text-sm",
    medium: "px-3 py-2 text-sm",
  }

  def admin_button(variant, size = :medium, link: false, delete: nil, post: nil, **options, &)
    classes = [
      "inline-block rounded-md text-center font-semibold shadow-sm",
      "focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2",
      ADMIN_BUTTON_SIZES.fetch(size),
      ADMIN_BUTTON_VARIANTS.fetch(variant),
      options[:class],
    ]

    if delete
      button_to(delete, method: :delete, class: classes, form_class: "m-0",
                        data: { turbo_confirm: "Are you sure?" }, **options, &)
    elsif post
      button_to(post, class: classes, form_class: "m-0",
                      data: { turbo_confirm: "Are you sure?" }, **options, &)
    elsif link
      tag.a(**options, href: link, class: classes, &)
    else
      tag.button(**options, class: classes, &)
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

  def admin_form(object = nil, automatic: false, **options, &)
    html_options = options[:html] || {}
    if automatic
      html_options["data-controller"] = "automatic-form"
    else
      html_options["data-turbo"] = false
    end

    tag.div class: html_options.delete(:class) { "sm:max-w-sm" } do
      options[:html] = { class: ["space-y-6"], **html_options }
      form_with model: object || false, builder: Admin::FormHelper::Builder, **options, &
    end
  end

  def admin_table(objects, &)
    render "admin/application/table", objects:, table_def: Admin::TableHelper::Definition.new(self, &)
  end

  def admin_paginate(scope)
    render "admin/application/pagination", scope:, current_page: [params[:page].to_i, 1].max
  end

  def admin_modal(id, title, &)
    render "admin/application/modal", id:, title:, &
  end
end
