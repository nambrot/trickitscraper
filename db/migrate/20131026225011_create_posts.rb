class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :uid
      t.text :body
      t.string :username
      t.string :link

      t.timestamps
    end

    add_index :posts, :uid, :unique => true
  end
end
