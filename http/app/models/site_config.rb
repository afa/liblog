class SiteConfig < ActiveRecord::Base
 validates_uniqueness_of :name
 def self.[] ( name )
  val = self.find_by_name(name.to_s)
  val.nil? ? nil : val.value
 end
 def self.[]= (name, value)
  cfg = self.find_or_create_by_name :name=>name.to_s
  cfg.value = value
  cfg.save
  value
 end
end
