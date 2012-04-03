# Title: A Liquid tag for Jekyll sites that allows embedding image file on 
#        Instagram.
# Authors: Nobuhiro Nikushi https://twitter.com/#!/niku4i
# Description: Easily embed image file on Instagram page.
#
# Syntax {% instag [class name(s)] http://instagr.am/p/IYYs5bo0jd/ [width [height]] [title text | "title text" ["alt text"]] %}
#
# Examples:
# {% instag http://instagr.am/p/IYYs5bo0jd/ %}
# {% instag left half http://instagr.am/p/IYYs5bo0jd/ my title %}
# {% instag left half http://instagr.am/p/IYYs5bo0jd/ 150 150 "my title" "our title" %}
#
# Output:
# <img src="http://path/to/istagram/image.jpg">
# <img class="left half" src="http://path/to/instagram/image.jpg" title="my title" alt="my title">
# <img class="left half" src="http://path/to/instagram/image.jpg" width="150" height="150" title="my title" alt="our title">
#

require 'open-uri'
require 'json'

module Jekyll

  class InsTag < Liquid::Tag
    def initialize(tag_name, text, token)
      super
      @text = text
      @cache_disabled = false
      @cache_folder   = File.expand_path "../.instag-cache", File.dirname(__FILE__)
      FileUtils.mkdir_p @cache_folder
    end

    def render(context)
      attributes = ['class', 'src', 'width', 'height', 'title']
      img = nil

      if @text =~ /(?<class>\S.*\s+)?(?<src>https?:\/\/\S+)(?:\s+(?<width>\d+))?(?:\s+(?<height>\d+))?(?<title>\s+.+)?/i
        img = attributes.reduce({}) { |h, attr| h[attr] = $~[attr].strip if $~[attr]; h }
        code = get_code_for img['src']
        instagram = get_cache_for(img['src']) || get_from_web(img['src'])

        img['src'] = instagram.fetch('url', nil)
        if /(?:"|')(?<title>[^"']+)?(?:"|')\s+(?:"|')(?<alt>[^"']+)?(?:"|')/ =~ img['title']
          img['title'] = title
          img['alt']   = alt
        else
          if img['title']
            img['alt'] = img['title'].gsub!(/"/, '&#34;') 
          elsif instagram['title']
            img['title'] = instagram['title'] 
            img['alt']   = instagram['title']
          end
        end
        img['class'].gsub!(/"/, '') if img['class']
      end

      if img
        "<img #{img.collect {|k,v| "#{k}=\"#{v}\"" if v}.join(" ")}>"
      else
        ""
      end
    end

    def get_cache_for(url)
      return nil if @cache_disabled
      code = get_code_for url
      return nil unless code
      cache_file = get_cache_file_for code
      JSON.parse(File.read(cache_file)) if File.exist? cache_file
    end

    def get_code_for(url)
      if url =~ %r|http://instagr.am/p/(\w+)/?|
        $1
      else
        return nil
      end
    end

    def get_cache_file_for(code)
      bad_chars = /[^a-zA-Z0-9\-_.]/
      code      = code.gsub bad_chars, ''
      File.join @cache_folder, "#{code}.cache"
    end

    def get_from_web(url)
      code = get_code_for url
      url = 'http://api.instagram.com/oembed?url=' + url
      data = JSON.parse(open(url).read)
      cache code, data unless @cache_disabled
      data
    end

    def cache(code, data)
      cache_file = get_cache_file_for code
      File.open(cache_file, "w") do |io|
        io.write(JSON.generate(data))
      end
    end
  end

  class InsTagNoCache < InsTag
    def initialize(tag_name, text, token)
      super
      @cache_disabled = true
    end
  end

end

Liquid::Template.register_tag('instag', Jekyll::InsTag)
Liquid::Template.register_tag('instagnocache', Jekyll::InsTagNoCache)
