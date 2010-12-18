module Fb2
 require "nokogiri"
  class << self
  def load_xml(fname)
   doc = nil
   File.open(fname, 'r') do |file|
    doc = Nokogiri::XML(file, nil, 'utf-8')
   end
   return nil unless doc
   doc.remove_namespaces!
   doc
  end

  def extract_xml_part(doc, part)
   doc.xpath(part)
  end



  def build_images_from_paragraph(gc, paragraph, params = {:height=>370, :width=>270, :used => 0}, last_img = nil)
    images = []
    img = last_img || Magick::Image.new(300, 400)
    words = paragraph.mb_chars.split(/\s+/)
    used = params[:used]
    strings = []
    until words.empty?
      cnt = 1
      while cnt <= words.size and gc.get_multiline_type_metrics(img, "#{words[0, cnt].join(' ')} ").width < params[:width]
        cnt += 1
      end
      cnt -= 1 unless gc.get_multiline_type_metrics(img, "#{words[0, cnt].join(' ')} ").width < params[:width]
      strings << "#{words[0, cnt].join(' ')} "
      cnt.to_i.times {  words.shift }
    end
    #in strings para strings
    until strings.empty?
      cnt = 1
      while gc.get_multiline_type_metrics(img, strings[0, cnt].join("\n")).height < (params[:height] - used) and cnt <= strings.size
        cnt += 1
      end
      cnt -= 1 unless gc.get_multiline_type_metrics(img, strings[0, cnt].join("\n")).height < (params[:height] - used)
      puts "#{cnt} lines"
      if cnt == 0
        used = 0
        images << img
        img = Magick::Image.new(300, 400)
      else
        h = gc.get_type_metrics(img, strings[0]).height
        gc.annotate(img, params[:width], params[:height], 15, h + used + 15, strings[0, cnt].join("\n"))
        used += gc.get_multiline_type_metrics(img, strings[0, cnt].join("\n")).height
      end
      if used >= params[:height]
        images << img
        img = Magick::Image.new(300, 400)
        used = 0
      end
      cnt.times { strings.shift }
    end
    return used, img, images
  end

#  def self.generate_pages(format, section_text, title_text, last_pos, max_pages)
  def generate_previews(book, section_text, title_text, last_pos, max_pages)
    return [] if book.preview_pages.count >= max_pages
    files_list = []
    need_pages = max_pages - book.preview_pages.count
    font_type = "/usr/local/lib/X11/fonts/webfonts/tahoma.ttf"
    #font to params
    font_style = Magick::NormalStyle
    gc = Magick::Draw.new do
      self.encoding = "utf-8"
      self.font = font_type #_family
      self.font_style = font_style
      self.pointsize = 12
    end
    title_gc = Magick::Draw.new do
      self.encoding = "utf-8"
      self.font = font_type #_family
      self.font_style = font_style
      self.font_weight = Magick::BoldWeight
      self.pointsize = 14
    end

    used = 0
    last_img = nil
    images = []
    title_paras = title_text.split("\n")
    title_paras.each do |title_para|
      break if images.size >= need_pages
      break if title_para.blank?
      used, last_img, img_arr = build_images_from_paragraph(title_gc, title_para, {:height=>370, :width=>270, :used =>used}, last_img)
      used += 8 #after paragraph gap
      puts "title used #{used}"
      img_arr.each{|i| images << i }
    end
    paras = section_text.split("\n")
    paras.each do |para|
      break if images.size >= need_pages
      used, last_img, img_arr = build_images_from_paragraph(gc, para, {:height=>370, :width=>270, :used =>used}, last_img)
      used += 8 #after paragraph gap
      puts "used #{used}"
      img_arr.each{|i| images << i }
    end
    images << last_img if last_img and images.size < need_pages
    i = 0
    images = images[0, need_pages]
    puts "pages count #{images.size}"
    images.each do |img|
      i += 1
      #format change
      img.write("/tmp/#{book.id || 'unid_format'}_#{i}.png")
      book.preview_pages.create :position => (last_pos + i), :image => File.open("/tmp/#{book.id || 'unid_format'}_#{i}.png")
      files_list << "/tmp/#{book.id || 'unid_format'}_#{i}.png"
    end
    files_list.each{|n| FileUtils.rm_f n }
  end
 end
end
