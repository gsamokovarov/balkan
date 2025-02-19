class Admin::ApplicationController < ApplicationController
  include Authentication

  layout -> { turbo_frame_request? ? "turbo_rails/frame" : "admin/application" }

  private

  def scope(relation) = relation.order(id: :desc).page(params[:page], per_page: params[:per_page] || 50)
end
