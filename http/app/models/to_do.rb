class ToDo < ActiveRecord::Base
 belongs_to :parent, :class_name=>'ToDo', :foreign_key=>'parent_id'
 has_many :childs, :class_name=>'ToDo',  :foreign_key=>:parent_id, :dependent=>:delete_all

 named_scope :with_childs, :include=>[:childs]
 named_scope :by_id, lambda{ |id| :conditions=>{:id=>id} unless id.blank?}
 named_scope :roots, :conditions=>{:parent_id => nil}

 def percent_done
  done, total = self.calc_percent
  return 100*done/total
 end

 protected

 def calc_percent
  done = total = 0
  self.childs.each do | child |
   a, b = child.calc_percent
   done += a
   total += b
  end
  total += 1
  done += 1 if self.done
  return done, total
 end

end
