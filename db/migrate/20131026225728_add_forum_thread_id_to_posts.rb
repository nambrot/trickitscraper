class AddForumThreadIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :forum_thread_id, :integer
  end
end
