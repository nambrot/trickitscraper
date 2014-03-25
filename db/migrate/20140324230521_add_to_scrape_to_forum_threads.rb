class AddToScrapeToForumThreads < ActiveRecord::Migration
  def change
    add_column :forum_threads, :to_scrape, :boolean, default: false
  end
end
