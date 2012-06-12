before '/*.rss' do
  content_type 'application/xml'
end

get '/:tags.rss' do
  @tags = params[:tags].split(/\s/)
  @title = "danboorss #{@tags}"
  imgs = TmpCache.get(@tags.join('+')) || TmpCache.set(@tags.join('+'), Danbooru.search(@tags), 3600*4)
  rss = RSS::Maker.make('2.0') do |rss|
    rss.channel.about = "#{app_root}#{ENV['PATH_INFO']}"
    rss.channel.title = @title
    rss.channel.link = Danbooru.search_url @tags
    rss.channel.description = @title
    imgs.each do |img|
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
  rss.to_s
end
