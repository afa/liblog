class AddNoncreatedIndexes < ActiveRecord::Migration
  def self.up
   add_index :users, [:identity_id]
   add_index :to_dos, [:project_id]
   add_index :to_dos, [:parent_id]
   add_index :things, [:thingable_id]
   add_index :taggings, [:tagger_id]
   add_index :taggings, [:taggable_id]
   #add_index :roles_users, [:role_id]
   #add_index :roles_users, [:user_id]
   #add_index :roles, [:authorizable_id]
   add_index :imported_entries, [:blog_post_id]
   add_index :books_genres, [:genre_id]
   add_index :books_genres, [:book_id]
   add_index :blog_posts, [:identity_id]
   add_index :blog_comments, [:user_id]
   add_index :blog_comments, [:blog_post_id]
   add_index :blog_comments, [:blog_comment_id]
   add_index :authors_books, [:author_id]
   add_index :authors_books, [:book_id]
   add_index :articles, [:author_id]
  end

  def self.down
  end
end
