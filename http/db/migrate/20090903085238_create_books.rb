class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string :name
      t.string :lre_name
      t.integer :lang_id
      t.integer :bundle_id
      t.timestamps
    end
    add_index :books, [:name], :name=>'books_name_idx', :uniq=>false
    add_index :books, [:lre_name], :name=>'books_lre_name_uniq_idx', :uniq=>true
    add_index :books, [:bundle_id], :name=>'books_bundle_id_idx'
    add_index :books, [:lang_id], :name=>'books_lang_id_idx'
  end

  def self.down
    remove_index :books, 'books_name_idx'
    remove_index :books, 'books_lre_name_uniq_idx'
    remove_index :books, 'books_bundle_id_idx'
    remove_index :books, 'books_lang_id_idx'
    drop_table :books
  end
end
