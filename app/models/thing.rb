# coding: UTF-8
class Thing < ActiveRecord::Base
  belongs_to :thingable, :polymorphic=>true
end
