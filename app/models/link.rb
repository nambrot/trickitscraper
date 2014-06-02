class Link < ActiveRecord::Base
  extend InterestingChecker
  def is_interesting?
    Link.is_interesting?(self.name)
  end
  def interesting_date
    created_at
  end
end
