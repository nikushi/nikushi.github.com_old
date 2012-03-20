# Title: A Liquid tag for Jekyll sites that allows embedding image file on Instagram.
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
    @img = nil
    @instagram = nil

    def initialize(tag_name, markup, tokens)
      super
      attributes = ['class', 'src', 'width', 'height', 'title']

      if markup =~ /(?<class>\S.*\s+)?(?<src>https?:\/\/\S+)(?:\s+(?<width>\d+))?(?:\s+(?<height>\d+))?(?<title>\s+.+)?/i
        @img = attributes.reduce({}) { |img, attr| img[attr] = $~[attr].strip if $~[attr]; img }
        @instagram = get_info(@img['src']) if @img['src']
        @img['src'] = @instagram.fetch('url', nil)
        if /(?:"|')(?<title>[^"']+)?(?:"|')\s+(?:"|')(?<alt>[^"']+)?(?:"|')/ =~ @img['title']
          @img['title']  = title
          @img['alt']    = alt
        else
          if @img['title']
            @img['alt']    = @img['title'].gsub!(/"/, '&#34;') 
          elsif @instagram['title']
            @img['title'] = @instagram['title'] 
            @img['alt'] = @instagram['title']
          end
        end
        @img['class'].gsub!(/"/, '') if @img['class']
      end
    end

    def render(context)
      if @img
        "<img #{@img.collect {|k,v| "#{k}=\"#{v}\"" if v}.join(" ")}>"
      else
        "Error processing input, expected syntax: {% instag [class name(s)] http[s]://path/to/instagram/image.jpg [width [height]] [title text | \"title text\" [\"alt text\"]] %}"
      end
    end

    private 
    def get_info(url)
      url = 'http://api.instagram.com/oembed?url=' + url
      JSON.parse(open(url).read)
    end
  end
end

Liquid::Template.register_tag('instag', Jekyll::InsTag)
