class FinalCountdown
  def self.until(date)
    days = date - Date.current
    return new days:, hours: 0 if days.negative?

    seconds = date.end_of_day - Time.current
    hours = (seconds % 1.day) / 1.hour

    new days:, hours:
  end

  attr_reader :days, :hours

  def initialize(days:, hours:)
    @days = days.to_i
    @hours = hours.to_i
  end

  def counters = [["days", days], ["hours", hours]]
  def ongoing? = days >= 0
end
