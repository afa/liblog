class CreatePreviewPages < ActiveRecord::Migration
  def self.up
    create_table :preview_pages do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.integer :position
      t.integer :book_id
      t.timestamps
    end
    add_index :preview_pages, [:book_id]
  end

  def self.down
    drop_table :preview_pages
  end
end
