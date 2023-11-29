module Precondition
  class Error < StandardError
    attr_reader :metadata

    def initialize(message, metadata:)
      super message
      @metadata = metadata
    end
  end

  class << self
    include Precondition

    def stop_execution?
      !Rails.env.production?
    end
  end

  def assert(condition, message = nil, **metadata)
    return if condition

    error = Error.new(message, metadata:)
    error.set_backtrace caller[1..]

    if Precondition.stop_execution?
      raise error
    else
      Rails.error.report(error, handled: true, **metadata)
    end
  end

  def assertion_failure(message = "Assertion failure", **metadata)
    error = Error.new(message, metadata:)
    error.set_backtrace caller[1..]

    if Precondition.stop_execution?
      raise error
    else
      Rails.error.report(error, **metadata)
    end
  end

  def precondition(condition, message = "Precondition failure", **metadata)
    return if condition

    error = Error.new(message, metadata:)
    error.set_backtrace caller[1..]

    raise error
  end

  def precondition_failure(message = "Precondition failure", **metadata)
    error = Error.new(message, metadata:)
    error.set_backtrace caller[1..]

    raise error
  end
end

