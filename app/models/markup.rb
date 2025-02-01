require "redcarpet/render_strip"

# Don't call this module Makrdown, as it conflicts with the Markdown class that
# is now also called RedcarpetCompat. Markup is the best name I found. I like it!
module Markup
  extend self

  INLINE_IMAGE_PLACEHOLDER = /\[(\d+)\]/

  class PlainTextRenderer < Redcarpet::Render::StripDown
    def paragraph(text) = "#{text}\n\n"
    def header(text, _header_level) = "#{text}\n\n"
  end

  class HTMLRenderer < Redcarpet::Render::HTML
    def link(link, title, content) = %(<a href="#{link}" title="#{title}" class="link-primary">#{content}</a>)
    def image(link, title, alt) = %(<img src="#{link}" title="#{title}" alt="#{alt}" class="border-2 border-black rounded-md">)
  end

  def render_html(content, inline_images: nil)
    @html_renderer ||= Redcarpet::Markdown.new HTMLRenderer, autolink: true, tables: true, strikethrough: true

    if inline_images
      content.gsub! INLINE_IMAGE_PLACEHOLDER do
        "![image #{it[1]}](#{Link.url_for inline_images[it[1].to_i - 1]})"
      end
    end

    @html_renderer.render content
  end

  def render_plain(content)
    @plain_renderer ||= Redcarpet::Markdown.new PlainTextRenderer
    @plain_renderer.render content
  end
end
