class AddMarkedAsFastGrowingAtToForumThreads < ActiveRecord::Migration
  def change
    add_column :forum_threads, :marked_as_fast_growing_at, :date, default: nil
  end
end
