class ActivityAggregator
  def initialize(streams)
    @streams = streams
  end

  def next_activities(limit)
    activities = []
    while (activities.size < limit) && more_activities? do
      activities << next_activity
    end
    activities
  end

private
  def next_activity
    @streams.select{ |s| has_next?(s) }.
      sort_by{ |s| s.peek.created_at }.
      last.next
  end

  def more_activities?
    @streams.any?{ |s| has_next?(s) }
  end

  def has_next?(stream)
    stream.peek
    true
  rescue
    false
  end
end