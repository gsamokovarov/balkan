class DateCountdown
  def self.until(date)
    days = date - Date.current
    hours = Time.current.seconds_until_end_of_day / 1.hour

    new days:, hours:
  end

  attr_reader :days, :hours

  def initialize(days:, hours:)
    @days = days.to_i
    @hours = days.negative? ? 0 : hours
  end

  def counters = [["days", days], ["hours", hours]]
  def past? = days.negative?
end
