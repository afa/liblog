class PreviewPage < ActiveRecord::Base
 has_attached_file :image

 def self.generate_previews(nokogiri_data)
        begin
          position = 1
          fname = self.full_path
          dirname = nil
          puts "#{fname}"
          if `file '#{fname}'` =~ /Zip archive data/
            dirname, fname = unzip_format_file(fname)
          end
          file_type = `file #{fname}`
          if file_type =~ /XML/ or file_type =~ / text, with very long lines/
            make_testpages_from_xml(fname, max_pages, position)
          else
            puts file_type
          end
        ensure
          FileUtils.rm_r dirname, :verbose=>true if dirname
        end
 end

end
