namespace :logs do

 desc "paarse nginx logs, scan day statistics"
 task :parse => :environment do
  # load logs from NGINXLOGS_PATH (by mask NGINXLOGS_MASK) and extract statistics per day.
 # ксли собранная цифра за день больше - она заменяет предыдущую.
  stats = {} # by dates
  NGINXLOGS_MASK.each do |mask|
   Dir.glob(File.join(NGINXLOGS_PATH, mask)) { |name|
    File.open(name, 'r') { |file|
     file.each { |l|
      l.scan(/^(\d+\.\d+\.\d+\.\d+)\s+.+?\s+.+?\s+\[(.+?)\]\s+\"(\S+)\s(\S+)\s+(\S+)\"\s+(\d+)\s+(\d+)\s+\"(\S+?)\"/){ |ip, ts, meth, url, proto, cod, siz, ref|
       d = DateTime.strptime(ts, "%d/%b/%Y:%T %z")
       stats[d.strftime("%Y-%m-%d")] ||= {} 
       stats[d.strftime("%Y-%m-%d")][ip] ||= []
       stats[d.strftime("%Y-%m-%d")][ip] << [url, ref]
      }
     }
    }
   }
  end
  stats.each { |k, v|
   x = v.values.inject(0) { |r, z| r+z.size  }
   s = Total.find :first, :conditions=>{ :for_day=>Date.strptime(k, "%Y-%m-%d")}
   s=Total.create :for_day=>Date.strptime(k, "%Y-%m-%d"), :counter=>x if s.nil?
   s.update_attribute :counter, x if x > s.counter
   s = Uniq.find :first, :conditions=>{ :for_day=>Date.strptime(k, "%Y-%m-%d")}
   s=Uniq.create :for_day=>Date.strptime(k, "%Y-%m-%d"), :counter=>v.keys.size if s.nil?
   s.update_attribute :counter, v.keys.size if v.keys.size > s.counter
  }
 end

end
