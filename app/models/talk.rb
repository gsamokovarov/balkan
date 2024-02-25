class Talk < ApplicationFrozenRecord
  Speaker = Data.define :name, :avatar, :github_url, :social_url, :about, :talk

  def speakers
    super.map { Speaker.new(**_1, talk: self) }
  rescue StandardError
    precondition_failure "Invalid speakers for talk ##{id}"
  end
end
