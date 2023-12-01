module Link
  extend self

  class ActionViewProxy < ActionView::Base
    include Rails.application.routes.url_helpers

    def default_url_options
      Rails.application.routes.default_url_options
    end
  end

  delegate_missing_to :proxy

  private

  def proxy
    @proxy ||= ActionViewProxy.empty
  end
end
