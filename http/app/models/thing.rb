class Thing < ActiveRecord::Base
  belongs_to :thingable, :polymorphic=>true
end
