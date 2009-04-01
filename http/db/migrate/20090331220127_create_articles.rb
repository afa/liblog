class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.column :title, :string
      t.column :text, :text
      t.column :name, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
