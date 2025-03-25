class Admin::MarkdownPreviewsController < Admin::ApplicationController
  def create
    html = helpers.render_markdown params[:content]

    render json: { html: }
  end
end
