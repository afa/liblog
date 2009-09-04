class Author < ActiveRecord::Base
 has_and_belongs_to_many :books

 def name
  [self.first_name, self.last_name].compact.join ' '
 end
end
