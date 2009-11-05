class Thing < ActiveRecord::Base
  belongs_to :some_thing
  belongs_to :thingable, :polymorphic=>true
end
