module Admin::TableHelper
  class Column
    def initialize(view_context, name = nil, getter = nil, &block)
      @view_context = view_context
      @name = name.is_a?(Proc) ? nil : name
      @getter = name.is_a?(Proc) ? name : (getter || block)

      precondition @name || @getter, "name or getter must be provided"
    end

    def header = @name.is_a?(String) ? @name : @name&.to_s&.humanize
    def value(object) = @getter ? @view_context.instance_exec(object, &@getter) : object.public_send(@name)
  end

  class Definition
    attr_reader :columns

    def initialize(view_context, &)
      @view_context = view_context
      @columns = []

      instance_eval(&)
    end

    def column(...) = @columns << Column.new(@view_context, ...)
  end
end
