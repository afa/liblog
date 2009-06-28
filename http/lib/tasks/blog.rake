namespace "blog" do

  desc 'Import external pictures & convert links to it'
  task :grab_pics => :environment do
    BlogPost.find(:all).each do | post |
     post.text.scan(/<img .*src=\"(.+?)\".*>/) { |m| puts "#{post.id}-#{m}"}
    end

  end
  desc 'Convert links to self journal to blog posts'
  task :conv_self_links => :environmentt do
    ljuser = SiteConfig["lj.user"]
    ljuser2 = ljuser.gsub(/_/, '-')
    urlexp = /^http:\/\/(users\.livejournal.com\/#{ljuser}|#{ljuser2}\.livejournal\.com)(.*)$/

  end
end
