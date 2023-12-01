module Link
  extend self

  class ActionViewProxy < ActionView::Base
    include Rails.application.routes.url_helpers

    def default_url_options = Rails.application.routes.default_url_options
  end

  delegate_missing_to :proxy

  def with_lts_domain
    precondition Rails.configuration.lts_domain, "LTS domain is not configured"

    old_domain = proxy.default_url_options[:host]
    proxy.default_url_options[:host] = Rails.configuration.lts_domain

    yield
  ensure
    proxy.default_url_options[:host] = old_domain
  end

  private

  def proxy
    @proxy ||= ActionViewProxy.empty
  end
end
