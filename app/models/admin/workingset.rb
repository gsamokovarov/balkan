class Admin::Workingset
  def initialize(scope, current)
    @ids = scope.pluck :id
    @index = @ids.index current.id

    precondition @index.present?, "Current record is not in the scope"
  end

  def position = @index + 1
  def total = @ids.size
  def prev = @index.positive? ? @ids[@index - 1] : nil
  def next = @index < @ids.size - 1 ? @ids[@index + 1] : nil
end
