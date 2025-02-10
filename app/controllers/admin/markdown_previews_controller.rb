class Admin::MarkdownPreviewsController < Admin::ApplicationController
  def create
    html = helpers.render_markdown params[:markdown]

    render json: { html: }
  end
end
