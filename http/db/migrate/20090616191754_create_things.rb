class CreateThings < ActiveRecord::Migration
  def self.up
    create_table :things do |t|
      t.string :name, :null=>false
      t.string :title
      t.integer :some_things_id
      t.timestamps
    end
  end

  def self.down
    drop_table :things
  end
end
