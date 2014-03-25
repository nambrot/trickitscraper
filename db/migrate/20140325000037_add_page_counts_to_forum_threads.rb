class AddPageCountsToForumThreads < ActiveRecord::Migration
  def change
    add_column :forum_threads, :page_counts, :text, default: [].to_yaml
  end
end
