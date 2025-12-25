class LiquidValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value.present? && Liquid::Template.parse(value)
  rescue Liquid::SyntaxError => err
    record.errors.add attribute, "contains invalid Liquid syntax: #{err.message}"
  end
end
