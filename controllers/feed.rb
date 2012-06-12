before '/*.rss' do
  content_type 'application/xml'
end

get '/tag/:tags.rss' do
  @tags = params[:tags].split(/\s/)
  @title = "danboorss #{@tags}"
  search = TmpCache.get(@tags.join('+')) || TmpCache.set(@tags.join('+'), Danbooru.search(@tags), 3600*4)
  make_rss("danboorss #{@tags}", search[:uri], search[:images]).to_s
end

get '/popular/:type.rss' do
  @type = params[:type].to_sym
  throw :halt, [404, 'not found'] unless [:day, :month, :week].include? @type
  popular = TmpCache.get(@type) || TmpCache.set(@type, Danbooru.popular(@type), 3600*4)
  make_rss("danboorss popular by #{@type}", popular[:uri], popular[:images]).to_s
end
