class StatsController < ApplicationController
  def index
   @stats = Stat.find( :all, :order=>'for_day DESC')
  end
end
