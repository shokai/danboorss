before '/*.rss' do
  content_type 'application/xml'
end

get '/tag/:tags.rss' do
  @tags = params[:tags].split(/\s/)
  @title = "danboorss #{@tags}"
  search = TmpCache.get(@tags.join('+')) || TmpCache.set(@tags.join('+'), Danbooru.search(@tags), 3600*4)
  rss = RSS::Maker.make('2.0') do |rss|
    rss.channel.about = "#{app_root}#{ENV['PATH_INFO']}"
    rss.channel.title = @title
    rss.channel.link = search[:uri]
    rss.channel.description = @title
    search[:images].each do |img|
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
