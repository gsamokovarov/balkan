class BlogPost < ApplicationFrozenRecord
  Author = Data.define :name, :about, :avatar

  def html_content = MarkdownRenderer.render content
  def author = Author.new(**super)

  class MarkdownRenderer < Redcarpet::Render::HTML
    def self.render(content)
      @renderer ||= Redcarpet::Markdown.new self, autolink: true, tables: true, strikethrough: true
      @renderer.render content
    end

    def link(link, title, content)
      %(<a href="#{link}" title="#{title}" class="link-primary" target="_blank">#{content}</a>)
    end
  end
end
