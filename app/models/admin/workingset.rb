class Admin::Workingset
  def self.for(record, in:)
    ids = binding.local_variable_get(:in).pluck :id
    index = ids.index record.id

    new ids, index if index
  end

  def initialize(ids, index)
    @ids = ids
    @index = index
  end

  def position = @index + 1
  def total = @ids.size
  def prev = @index.positive? ? @ids[@index - 1] : nil
  def next = @index < @ids.size - 1 ? @ids[@index + 1] : nil
end
