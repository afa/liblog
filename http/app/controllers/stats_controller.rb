class StatsController < ApplicationController
  def index
   @totals = Total.find(:all).inject({}){ |r, i| r[i.for_day]=i; r  }
   @uniqs = Uniq.find(:all).inject({}){ |r, i| r[i.for_day]=i; r  }
  end
end
