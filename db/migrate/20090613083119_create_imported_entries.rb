class CreateImportedEntries < ActiveRecord::Migration
  def self.up
    create_table :imported_entries do |t|
      t.column :source_server, :string
      t.column :source_created_at, :timestamp
      t.column :source_url, :string, :null=>false
      t.column :blog_post_id, :integer, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :imported_entries
  end
end
