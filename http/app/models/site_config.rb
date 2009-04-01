class SiteConfig < ActiveRecord::Base
 validates_uniqueness_of :name
 def self.[] ( name )
  val = self.find_by_name(name)
  val.nil? ? nil : val.value
 end
end
