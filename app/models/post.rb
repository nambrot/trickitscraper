class Post < ActiveRecord::Base

  validates :uid, uniqueness: true
end
