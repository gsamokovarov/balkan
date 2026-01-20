require "redcarpet/render_strip"

module MarkdownHelper
  # Don't call this module Makrdown, as it conflicts with the ::Markdown class
  # that is now also called RedcarpetCompat. Markup is the best name I found. I
  # like it!
  module Markup
    extend self

    INLINE_IMAGE_PLACEHOLDER = /\[(\d+)\]/

    DEFAULT_EXTENSIONS = {
      autolink: true,
      tables: true,
      strikethrough: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
    }

    class PlainTextRenderer < Redcarpet::Render::StripDown
      def paragraph(text) = "#{text}\n\n"
      def header(text, _header_level) = "#{text}\n\n"
      def link(_link, _title, content) = content
      def list_item(content, _type) = "• #{content}\n"
    end

    class HTMLRenderer < Redcarpet::Render::HTML
      def link(link, title, content) = %(<a href="#{link}" title="#{title}" class="link-primary">#{content}</a>)

      def image(link, title, alt)
        if link.end_with? ".mov", ".mp4", ".webm"
          return %(<video class="max-w-full border-2 border-black rounded-md" controls><source src="#{link}"></video>)
        end

        %(<img src="#{link}" title="#{title}" alt="#{alt}" class="max-w-full h-auto border-2 border-black rounded-md">)
      end
    end

    def render_html(content, images: nil)
      @html_renderer ||= Redcarpet::Markdown.new HTMLRenderer, **DEFAULT_EXTENSIONS

      if images
        content.gsub!(INLINE_IMAGE_PLACEHOLDER) { "![image #{it[1]}](#{Link.url_for images[it[1].to_i - 1]})" }
      end

      @html_renderer.render content
    end

    def render_plain(content)
      @plain_renderer ||= Redcarpet::Markdown.new PlainTextRenderer

      sanitizer = Rails::HTML::FullSanitizer.new
      sanitizer.sanitize @plain_renderer.render(content).strip
    end
  end

  def render_markdown(...) = Markup.render_html(...).html_safe
  def render_plain(...) = Markup.render_plain(...)
end
