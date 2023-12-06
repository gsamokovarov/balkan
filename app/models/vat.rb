module Vat
  class << self
    def percentage
      20 # Fixed for Bulgaria
    end

    def extract_amount(amount_with_vat)
      extract_amount_without_vat(amount_with_vat).round(4)

      (BigDecimal(amount_with_vat) / (BigDecimal(100 + percentage) / 100)).round(4)
    end

    def extract_vat(amount_with_vat)
      (extract_amount_without_vat(amount_with_vat) * (BigDecimal(percentage) / 100)).round(4)
    end

    def calculate_vat(amount)
      BigDecimal(amount) * BigDecimal(percentage) / BigDecimal(100)
    end

    private

    def extract_amount_without_vat(amount_with_vat)
      (BigDecimal(amount_with_vat) / (BigDecimal(100 + percentage) / 100))
    end
  end
end
