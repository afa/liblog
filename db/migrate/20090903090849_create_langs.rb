class CreateLangs < ActiveRecord::Migration
  def self.up
    create_table :langs do |t|
      t.string :name, :null=>false
      t.timestamps
    end
    add_index :langs, ['name'], :name=>'langs_name_uniq_idx'
  end

  def self.down
    remove_index :langs, 'langs_name_uniq_idx'
    drop_table :langs
  end
end
