class StaticSchedule < ApplicationFrozenRecord
  Timeslot = Data.define :time, :type, :talk_id do
    def talk? = talk_id.present?
    def talk = Talk.find(talk_id)
  end

  def timeslots = super.transform_values { |slots| slots.map { Timeslot.new(**_1) } }
end
