require "rails/generators"

class Admin::ScaffoldGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)
  argument :resource_name, type: :string
  class_option :skip_routes, type: :boolean, default: false, desc: "Don't add routes to config/routes.rb"

  def create_controller
    @resource_singular = resource_name.singularize
    @resource_plural = resource_name.pluralize
    @resource_class = @resource_singular.camelize
    @namespace_class = "Admin::#{@resource_plural.camelize}Controller"

    template "controller.rb.tt", "app/controllers/admin/#{@resource_plural}_controller.rb"
  end

  def create_views
    %w[index new show].each do |view|
      template "views/#{view}.html.erb.tt", "app/views/admin/#{@resource_plural}/#{view}.html.erb"
    end

    template "views/_form.html.erb.tt", "app/views/admin/#{@resource_plural}/_form.html.erb"
    template "views/_resources.html.erb.tt", "app/views/admin/#{@resource_plural}/_#{@resource_plural}.html.erb"
  end

  def add_routes
    return if options[:skip_routes]

    route_config = "    resources :#{@resource_plural}"

    if File.exist? "config/routes.rb"
      insert_into_file "config/routes.rb", "\n#{route_config}", after: /namespace :admin do\s*$/
    else
      say "config/routes.rb doesn't exist, skipping routes", :red
    end
  end
end
