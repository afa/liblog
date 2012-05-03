class CreateDefaultConfigs < ActiveRecord::Migration
  def self.up
   SiteConfig.find_or_create_by_name :name=>'lj.user',:value=>'afa_at_work'
   SiteConfig.find_or_create_by_name :name=>'lj.password',:value=>'ass-asin'
   SiteConfig.find_or_create_by_name :name=>'blog.user',:value=>'afa'

  end

  def self.down
  end
end
