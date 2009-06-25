class CreateSomeThings < ActiveRecord::Migration
  def self.up
    create_table :some_things do |t|
      t.string :base_path, :null=>false
      t.string :name, :null=>false
      t.integer :dir_count, :null=>false
      t.string :base_url, :null=>false
      t.timestamps
    end
    SomeThing.create :base_path=>File.join(RAILS_ROOT, 'files'), 
      :name=>'default', 
      :dir_count=>16,
      :base_url=>'/data'
  end

  def self.down
    drop_table :some_things
  end
end
