
def make_rss(title, link, items)
  RSS::Maker.make('2.0') do |rss|
    rss.channel.about = "#{app_root}#{ENV['PATH_INFO']}"
    rss.channel.title = title
    rss.channel.link = link
    rss.channel.description = title
    items.each do |img|
      begin
        i = rss.items.new_item
        i.title = img.permalink
        i.link = img.permalink
        i.description = "<p><img src=\"#{img.url}\"></p>"
      rescue => e
        STDERR.puts "#{e} (#{e.class})"
      end
    end
  end
end
