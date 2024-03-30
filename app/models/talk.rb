class Talk < ApplicationFrozenRecord
  Speaker = Data.define :name, :avatar, :github_url, :social_url, :about, :talk

  def speakers = super.map { Speaker.new(**_1, talk: self) }
  def speaker_names = speakers.map(&:name).to_sentence
end
