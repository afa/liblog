class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
     t.column :for_day, :date
     t.column :type, :string
     t.column :counter, :integer
#      t.timestamps
    end
  end

  def self.down
    drop_table :stats
  end
end
