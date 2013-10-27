class CreateForumThreads < ActiveRecord::Migration
  def change
    create_table :forum_threads do |t|
      t.integer :last_page_scraped
      t.string :link
      t.string :name

      t.timestamps
    end
  end
end
