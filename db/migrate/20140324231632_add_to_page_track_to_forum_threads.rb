class AddToPageTrackToForumThreads < ActiveRecord::Migration
  def change
    add_column :forum_threads, :to_page_track, :boolean, default: false
  end
end
