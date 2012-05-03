class AddCompressionToBundle < ActiveRecord::Migration
  def self.up
   add_column :bundles, :is_compressed, :boolean, :default => false
   Bundle.update_all "is_compressed = 'f'"
  end

  def self.down
   remove_column :bundles, :is_compressed
  end
end
