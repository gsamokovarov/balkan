class ContractTemplate < ApplicationRecord
  belongs_to :event

  validates :name, presence: true
  validates :content, presence: true, liquid: true
end
