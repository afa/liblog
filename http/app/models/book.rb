class Book < ActiveRecord::Base
 has_many :covers, :source=>:things, :as=>:thingable
 has_and_belongs_to_many :authors
 has_and_belongs_to_many :genres
 belongs_to :lang, :counter_cache=>true
 belongs_to :bundle, :counter_cache=>true

 after_save :update_count

 named_scope :unbundled, lambda { {:conditions=>'bundle_id is null'} }
 named_scope :only_50, {:limit=>50}
 named_scope :lasts, {:order=>'created_at DESC'}
 named_scope :with_authors, {:include=>[:authors]}

 include AASM

 aasm_column :state

 aasm_initial_state :created

 aasm_state :created # создан. остальное без гарантий
 aasm_state :prepared #, :enter=> , :exit=>
# авторы, язык, аннотация etc подготовлены.
 aasm_state :bundled #.fb2.desc и .fb2 упакованы
 aasm_state :published # активна
 aasm_state :blocked

 aasm_event :prepare do
  transitions :to => :prepared, :from => [:created]  #, :guard => , 
 end
 aasm_event :bundle do
  transitions :to => :bundled, :from => [:prepared], :guard => :check_bundled
 end
 aasm_event :publish do
  transitions :to => :published, :from => [:bundled], :guard => :check_ready
 end
 aasm_event :block do
  transitions :to => :blocked, :from =>[:created, :prepared, :bundled, :published]
 end
 aasm_event :restart do
  transitions :to => :prepared, :from => [:blocked]
 end
 ## callbacks, guards (protected)

 def Book.per_page
  30
 end

 private
  def update_count
   self.authors.each{|a| a.update_books_count}
   self.genres.each{|a| a.update_books_count}
   #self.lang.update_books_count
  end
 
end
