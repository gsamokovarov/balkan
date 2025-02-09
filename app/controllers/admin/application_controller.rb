class Admin::ApplicationController < ApplicationController
  include Authentication

  layout -> { turbo_frame_request? ? "turbo_rails/frame" : "admin/application" }
end
