before '/*.rss' do
  content_type 'application/xml'
end

before '/*.json' do
  content_type 'application/json'
end

get /\/tag\/(.+)\.(rss|json)/ do
  @tags = params[:captures].shift.split(/\s/)
  @ext = params[:captures].shift
  search = TmpCache.get(@tags.join('+')) || TmpCache.set(@tags.join('+'), Danbooru.search(@tags), 3600*4)
  case @ext
  when 'rss'
    make_rss("danboorss - #{@tags}", search[:uri], search[:images]).to_s
  when 'json'
    search.to_json
  end
end

get /\/popular\/(.+)\.(rss|json)/ do
  @type = params[:captures].shift.to_sym
  @ext = params[:captures].shift
  throw :halt, [404, 'not found'] unless [:day, :month, :week].include? @type
  popular = TmpCache.get(@type) || TmpCache.set(@type, Danbooru.popular(@type), 3600*4)
  case @ext
  when 'rss'
    make_rss("danboorss - popular by #{@type}", popular[:uri], popular[:images]).to_s
  when 'json'
    popular.to_json
  end
end
