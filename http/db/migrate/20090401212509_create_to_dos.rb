class CreateToDos < ActiveRecord::Migration
  def self.up
    create_table :to_dos do |t|
      t.column :text, :text
      t.column :to_date, :date
      t.column :parent, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :to_dos
  end
end
