class CreateDefaultRoles < ActiveRecord::Migration
  def self.up
    user = User.find_or_create_by_username( :username=>'afa')
    role = Role.find_or_create_by_name( :name=>'blogger', :title=>'Блоггер', :comment=>'Full access blogger')
    role.privileges << Privilege.find_or_create_by_name( :name=>'blog.post')
    role.privileges << Privilege.find_or_create_by_name( :name=>'blog.edit')
    role.privileges << Privilege.find_or_create_by_name( :name=>'blog.delete')
    role.save!
    user.roles << role
    role = Role.find_or_create_by_name( :name=>'blog_poster', :title=>'Постер в блог', :comment=>'Post and read access to blog')
    role.privileges << Privilege.find_or_create_by_name( :name=>'blog.post')
    role.save!
    role = Role.find_or_create_by_name( :name=>'configurer', :title=>'SiteConfig editor', :comment=>'Configuration modifier')
    role.privileges << Privilege.find_or_create_by_name( :name=>'config.view')
    role.privileges << Privilege.find_or_create_by_name( :name=>'config.edit')
    role.privileges << Privilege.find_or_create_by_name( :name=>'config.delete')
    user.roles << role
    role.save!
    role = Role.find_or_create_by_name( :name=>'registered', :title=>'registered user')
    role.privileges << Privilege.find_or_create_by_name( :name=>'user.login')
    user.roles << role
    role.save!
    role = Role.find_or_create_by_name( :name=>'todo', :title=>'Владелец ToDo')
    role.privileges << Privilege.find_or_create_by_name( :name=>'todo.view')
    role.privileges << Privilege.find_or_create_by_name( :name=>'todo.delete')
    role.privileges << Privilege.find_or_create_by_name( :name=>'todo.edit')
    role.privileges << Privilege.find_or_create_by_name( :name=>'todo.add')
    user.roles << role
    role.save!
    user.save!
  end

  def self.down
    Role.delete Role.find :all, :conditions => ['name in (:names)', {:names=>['todo', 'registered', 'configurer', 'blog_poster', 'blogger']}]
  end
end
