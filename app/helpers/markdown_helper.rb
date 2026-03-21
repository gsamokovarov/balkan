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

      def block_code(code, _language)
        %(<pre class="overflow-x-auto"><code>#{ERB::Util.html_escape code}</code></pre>)
      end

      def image(link, title, alt)
        if link.end_with? ".mov", ".mp4", ".webm"
          return %(<video class="max-w-full border-2 border-black rounded-md" controls><source src="#{link}"></video>)
        end

        %(<img src="#{link}" title="#{title}" alt="#{alt}" class="max-w-full h-auto border-2 border-black rounded-md">)
      end
    end

    class PDFRenderer < Redcarpet::Render::Base
      def initialize(document)
        super()
        @pdf = document
        @list_counter = 0
      end

      def paragraph(text)
        @pdf.text text, size: 11, inline_format: true, leading: 4
        @pdf.move_down 8
        ""
      end

      def header(text, level)
        sizes = { 1 => 22, 2 => 16, 3 => 13 }
        @pdf.move_down 8
        @pdf.text text, size: sizes.fetch(level, 11), style: :bold, inline_format: true
        @pdf.move_down level == 1 ? 8 : 4
        ""
      end

      def list_item(text, list_type)
        prefix = list_type == :ordered ? "#{@list_counter += 1}." : "\u2022"
        @pdf.indent 20 do
          @pdf.text "#{prefix} #{text.strip}", size: 11, inline_format: true, leading: 4
        end
        ""
      end

      def list(_content, _list_type)
        @list_counter = 0
        @pdf.move_down 8
        ""
      end

      def hrule
        @pdf.start_new_page
        ""
      end

      def double_emphasis(text) = "<b>#{text}</b>"
      def emphasis(text) = "<i>#{text}</i>"
      def normal_text(text) = text
      def codespan(code) = code
      def linebreak = "\n"
      def link(_link, _title, content) = content
      def autolink(link, _link_type) = link
      def doc_header = ""
      def doc_footer = ""
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

    def render_pdf(content, document:)
      renderer = PDFRenderer.new document
      md = Redcarpet::Markdown.new(renderer, **DEFAULT_EXTENSIONS)
      md.render content
      nil
    end
  end

  def render_markdown(...) = Markup.render_html(...).html_safe
  def render_plain(...) = Markup.render_plain(...)
  def render_pdf(...) = Markup.render_pdf(...)
end
