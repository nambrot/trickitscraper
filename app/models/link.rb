class Link < ActiveRecord::Base
  extend InterestingChecker
  def is_interesting?
    Link.is_interesting?(self.title)
  end
end
