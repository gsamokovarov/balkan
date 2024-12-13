class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def page(number, per_page: 50) = limit(per_page).offset(per_page * [number.to_i - 1, 0].max)
    def total_count = offset(nil).limit(nil).count

    def time_as_boolean(attribute, field: "#{attribute}_at")
      define_method attribute, -> { read_attribute(field).presence }
      define_method "#{attribute}=", -> value { write_attribute(field, value.presence ? Time.current : nil) }
    end
  end
end
