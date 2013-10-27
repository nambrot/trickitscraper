class Post < ActiveRecord::Base

  validates :uid, uniqueness: true

  def to_param
    self.uid
  end
end
