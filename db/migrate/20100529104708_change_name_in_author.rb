class ChangeNameInAuthor < ActiveRecord::Migration
  def self.up
   add_column :authors, :name, :string
   Author.all.each{|a| a.update_attributes :name => [a.first_name, a.last_name].compact.join(' ')}
  end

  def self.down
   remove_column :authors, :name
  end
end
