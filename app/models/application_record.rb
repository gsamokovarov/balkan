class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def page(number, per_page: 50) = limit(per_page).offset(per_page * [number.to_i - 1, 0].max)
    def total_count = offset(nil).limit(nil).count

    def time_as_boolean(attribute, field: "#{attribute}_at")
      define_method attribute, -> { read_attribute(field) ? true : false }
      define_method "#{attribute}=", -> value do
        write_attribute(field, value.in?(ActiveModel::Type::Boolean::FALSE_VALUES) ? nil : Time.current)
      end
      alias_method "#{attribute}?", attribute
    end

    def accepts_nested_attributes_for(*attr_names, destroy_missing: false, **options)
      options[:allow_destroy] = true if destroy_missing
      super(*attr_names, options)

      attr_names.each { |association_name| class_eval <<~RUBY, __FILE__, __LINE__ + 1 } if destroy_missing
        def #{association_name}_attributes=(attributes)
          if attributes.is_a?(Array)
            #{association_name}.ids.each do |id|
              attribute_id = attributes.find { it[:id] == id || it[:id] == id.to_s }&.fetch(:id)
              attributes << { id:, _destroy: true } unless attribute_id
            end
          end

          super(attributes)
        end
      RUBY
    end
  end
end
