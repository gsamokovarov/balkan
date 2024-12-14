class StaticSponsor < ApplicationFrozenRecord
  def self.basic = where type: "basic"
  def self.travel = where type: "travel"
  def self.party = where type: "party"
end
