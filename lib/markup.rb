require "redcarpet/render_strip"

# Don't call this module Makrdown, as it conflicts with the Markdown class that
# is now also called RedcarpetCompat. Markup is the best name I found. I like it!
module Markup
  extend self

  class PlainTextRenderer < Redcarpet::Render::StripDown
    def paragraph(text) = "#{text}\n\n"
    def header(text, _header_level) = "#{text}\n\n"
  end

  class HTMLRenderer < Redcarpet::Render::HTML
    def link(link, title, content) = %(<a href="#{link}" title="#{title}" class="link-primary">#{content}</a>)
  end

  def render_html(content)
    @html_renderer ||= Redcarpet::Markdown.new HTMLRenderer, autolink: true, tables: true, strikethrough: true
    @html_renderer.render content
  end

  def render_plain(content)
    @plain_renderer ||= Redcarpet::Markdown.new PlainTextRenderer
    @plain_renderer.render content
  end
end
