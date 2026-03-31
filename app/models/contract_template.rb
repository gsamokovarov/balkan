class ContractTemplate < ApplicationRecord
  belongs_to :event

  validates :name, presence: true
  validates :content, presence: true, liquid: true
  validates :language, presence: true, inclusion: { in: %w[bg en] }
end
