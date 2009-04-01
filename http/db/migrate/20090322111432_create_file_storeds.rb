class CreateFileStoreds < ActiveRecord::Migration
  def self.up
    create_table :file_storeds do |t|
      t.column :location, :string
      t.column :uri, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :file_storeds
  end
end
