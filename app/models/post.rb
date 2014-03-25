class Post < ActiveRecord::Base
  belongs_to :forum_thread
  validates :uid, uniqueness: true

  def to_param
    self.uid
  end
end
