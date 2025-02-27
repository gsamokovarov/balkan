===============================================================================

Admin scaffold for <%= @resource_class %> was successfully created.

Follow these steps to complete the setup:

1. Update model fields in controller's <%= @resource_singular %>_params method:
   - Edit app/controllers/admin/<%= @resource_plural %>_controller.rb
   - Add all permitted attributes in the <%= @resource_singular %>_params method

2. Update the form fields in app/views/admin/<%= @resource_plural %>/_form.html.erb:
   - Add the appropriate form fields for your <%= @resource_singular %> model
   - Use the available form helpers like:
     - f.text_input :field_name
     - f.number_input :amount
     - f.text_area_input :description
     - f.check_box_input :enabled
     - f.file_input :image
     - etc.

3. Update the table columns in app/views/admin/<%= @resource_plural %>/_<%= @resource_plural %>.html.erb:
   - Add columns that should be displayed in the index view

<% unless options[:skip_routes] %>
4. Routes have been added to config/routes.rb automatically.
   Check if there's any additional route configuration needed.
<% else %>
4. Add the following to your config/routes.rb file inside the admin namespace:
   resources :<%= @resource_plural %>
<% end %>

===============================================================================
