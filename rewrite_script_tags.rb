require 'fileutils'
require 'nokogiri'

ORIGINAL_EXT = '.original'
SHOWROOM_SCRIPT = %(
  <div class="showroom-widget" data-collection="auto" data-type="showlinks"></div>
  <script type="text/javascript" async>(function(d, s, id) {
    if (window._SR) {window._SR.init(); return;}
    if (d.getElementById(id)) {return;}
    var js = d.createElement(s), fjs = d.getElementsByTagName(s)[0];
    js.id = id; js.async = true; js.src = '//www.thisisshowroom.com/showroom.js?user=2948125830';
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', '_SR_script'));</script>
)

site = ARGV[0]
pages = Dir.glob("#{site}/**/*.html")

fail "no site path given" if site.empty?

def add_showroom(html)
  doc = Nokogiri::HTML(html)
  doc.at('body').add_child(SHOWROOM_SCRIPT)
  doc.to_html
end

def remove_skimlinks(html)
  doc = Nokogiri::HTML(html)
  doc.search('//script[contains(@src,"skimlinks.js")]').remove
  doc.to_html
end

def remove_google_tag_manager(html)
  doc = Nokogiri::HTML(html)
  doc.search('//script[text()[contains(.,"googletagmanager.com")]]').remove
  doc.to_html
end

puts "undoing previous run"
pages.each do |page|
  if File.exists?("#{page}#{ORIGINAL_EXT}")
    FileUtils.rm(page)
    FileUtils.mv("#{page}#{ORIGINAL_EXT}", page)
  end
end

puts "reading *.html files"
pages.map! do |page|
  [page, File.read(page)]
end

puts "selecting non-empty files"
pages.select! do |_, html|
  html && !html.empty?
end

puts "rewriting script tags"
pages.map! do |page, html|
  html = add_showroom(html)
  html = remove_skimlinks(html)
  html = remove_google_tag_manager(html)

  [page, html]
end

puts "writing modified *.html files"
pages.each do |page, html|
  FileUtils.mv(page, "#{page}#{ORIGINAL_EXT}")
  File.write(page, html)
end
