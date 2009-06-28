class SomeThing < ActiveRecord::Base
  has_many :things
  def prepare
   
  end
  attr_accessor :prepare
end
