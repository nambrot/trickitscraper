class ChangeLinkTitleToName < ActiveRecord::Migration
  def change
    rename_column :links, :title, :name
  end
end
