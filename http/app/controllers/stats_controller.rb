# coding: UTF-8
class StatsController < ApplicationController
  def index
   @totals = Total.all.inject({}){ |r, i| r.merge i.for_day=>i  }
   @uniqs = Uniq.all.inject({}){ |r, i| r.merge i.for_day=>i  }
  end
end
