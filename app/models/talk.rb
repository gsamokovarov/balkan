class Talk < ApplicationRecord
  has_and_belongs_to_many :speakers

  validates :name, presence: true

  def speaker_names = speakers.map(&:name).to_sentence
end
