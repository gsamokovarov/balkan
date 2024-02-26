class Sponsor < ApplicationFrozenRecord
  def self.basic = where type: "basic"
  def self.travel = where type: "travel"
end
