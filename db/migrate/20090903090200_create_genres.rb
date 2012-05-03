class CreateGenres < ActiveRecord::Migration
  def self.up
    create_table :genres do |t|
      t.string :name, :null=>false
      t.timestamps
    end
   create_table :books_genres, :id=>false do |t|
    t.integer :book_id, :null=>false
    t.integer :genre_id, :null=>false
   end
   add_index :genres, [:name], :name=>'genres_name_uniq_idx', :uniq=>true
   add_index :books_genres, [:book_id, :genre_id], :name=>'books_genres_uniq_idx', :uniq=>true
  end

  def self.down
   remove_index :genres, 'genres_name_uniq_idx'
   remove_index :books_genres, 'books_genres_uniq_idx'
    drop_table :books_genres
    drop_table :genres
  end
end
