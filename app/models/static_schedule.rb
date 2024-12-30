class StaticSchedule < ApplicationFrozenRecord
  class Timeslot
    attr_reader :time, :type, :talk

    def initialize(attributes = {})
      @time = attributes.with_indifferent_access[:time]
      @type = attributes.with_indifferent_access[:type]
      @talk = Talk.find_by id: attributes.with_indifferent_access[:talk_id]
    end
  end

  def timeslots = super.transform_values { |slots| slots.map { Timeslot.new(**it) } }
end
