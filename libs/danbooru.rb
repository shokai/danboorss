require 'nokogiri'
require 'net/http'

module Danbooru

  private
  def self.get_images(html)
    html.xpath('//a').reject{|a|
      a['href'] !~ /^\/post\/show\/\d+/
    }.map{|a|
      Image.new a['href'].scan(/^\/post\/show\/(\d+)/)[0][0].to_i
    }
  end

  public
  def self.search(*tags)
    uri = URI.parse "http://danbooru.donmai.us/post?tags=#{tags.join '+'}"    
    res = Net::HTTP.start(uri.host, uri.port).
      request(Net::HTTP::Get.new uri.request_uri)
    raise Error.new, "HTTP Status #{res.code} at #{uri}" unless res.code.to_i == 200
    {
      :uri => uri,
      :images => get_images(Nokogiri::HTML res.body)
    }
  end

  class Image
    attr_reader :id, :permalink
    def initialize(id)
      raise ArgumentError, 'id must be Number' unless id.kind_of? Fixnum
      @id = id
      @permalink = URI.parse "http://danbooru.donmai.us/post/show/#{@id}"
    end

    def html
      @html ||= (
                 res = Net::HTTP.start(permalink.host, permalink.port).request(Net::HTTP::Get.new permalink.request_uri)
                 raise Error.new, "HTTP Status # => {res.code} at #{permalink}" unless res.code.to_i == 200
                 Nokogiri::HTML res.body
                 )
    end

    def url
      @url ||= (
                tags = html.xpath('//img[@id="image"]')
                raise Error, 'Image URL not found' if tags.empty?
                tags[0]['src']
                )
    end
  end

  class Error < StandardError
  end
end


if $0 == __FILE__
  word = ARGV.empty? ? 'happy' : ARGV
  puts "search : #{word}"
  Danbooru.search(word)[:images].each do |img|
    begin
      puts "#{img.permalink} => #{img.url}"
    rescue => e
      STDERR.puts "#{e} (#{e.class})"
    end
    sleep 1
  end
end
