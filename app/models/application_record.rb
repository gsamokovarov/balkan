class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.page(number, per_page: 50) = limit(per_page).offset(per_page * [number.to_i - 1, 0].max)
end
