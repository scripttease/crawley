#!/usr/bin/env ruby

require 'httparty'
require 'nokogiri'
require 'json'
require 'pry'
require 'csv'
require 'set'
require 'uri'


# TODO name change to Crawley
class Crawler
  def initialize(input_url)
    @input_url = input_url
    @visited_urls = {} # { visited_url => [static_assets], ...}
    @unvisited_urls = Set.new([input_url])
  end

  def run!
    while @unvisited_urls.any?
      scrape_next_url!
    end
    @visited_urls
  end

  private

  def scrape_next_url!
    # Takes a url out of unvisited set in order to scrape and parse
    next_url = @unvisited_urls.first
    @unvisited_urls.delete(next_url)

    puts "Scraping #{next_url}"

    page = MyParty.get(next_url).body
    #TODO error handling in case site is down or url invalid
    assets = Parser.new(page).asset_parser

    # Adds the current (next_url) url to the visited url hash
    # with its assets
    @visited_urls[next_url] = assets

    @hrefs = Parser.new(page).href_parse
    full_hrefs = UrlManager.new(@input_url, @hrefs).prefix_hrefs

    @unvisited_urls = @unvisited_urls + (full_hrefs - @visited_urls.keys)
  end
end

#TODO ensure this handles 404 and no connection
class MyParty
  def self.get(*args)
    begin
      response = HTTParty.get(*args)
    rescue HTTParty::Error
      case response.code
      when 200
        response
      when 404
        puts "Not found!"
      when 500...600
        puts "Error #{response.code}"
      end
    end
  end
end

class Parser
  # def initialize(parsed_page = Nokogiri::HTML(page))
  #   @parsed_page = parsed_page
  def initialize(page)
    @parsed_page= Nokogiri::HTML(page)
  end

  # returns array of paths for site page links
  def href_parse
    href_elems = @parsed_page.css('a[href]')
    href_elems.map do |elem|
      elem.attributes["href"].value
    end
  end

  def asset_parser
    # TODO add hosts
    link_elems = href_parser('link[href]', 'href')
    link_elems_filtered = asset_link_filter(link_elems)
    script_elems = href_parser('script[src]', 'src')
    img_elems = href_parser('img[src]', 'src')
    (script_elems + img_elems + link_elems_filtered).flatten.uniq
  end

  # Returns array of href values for css selector[attribute]
  def href_parser(selector_attr, attrb)
    href_elems = @parsed_page.css(selector_attr)
    href_elems = href_elems.map do |elem|
      elem.attributes[attrb].value
    end
  end

  # Remove page url links from assets array
  def asset_link_filter(asset_array)
    asset_array.select do |asset|
      asset.split(//).last != '/'
    end
    #TODO also filter out .html endings
  end
end

class UrlManager
  def initialize(input_url, hrefs)
    @hrefs = hrefs
    @input_url = input_url
  end

  def fragment_filter(hrefs)
    # filters out hrefs that are in-page anchors
    hrefs.select do |href|
      href.split(//).first != '#'
    end
  end

  def prefix_hrefs
    input_url_scheme = URI(@input_url).scheme
    input_url_host = URI(@input_url).host
    if input_url_scheme == 'http'
      input_url_root = URI::HTTP.build({host: input_url_host})
    else
      input_url_root = URI::HTTPS.build({host: input_url_host})
    end
    valid_hrefs = fragment_filter(@hrefs)
    urls = valid_hrefs.map do |href|
      begin
        URI.join(input_url_root, href.strip)
      rescue URI::InvalidURIError
        nil
      end
    end.compact
    # Ensures that only input_urls with the same host are returned
    # TODO extract into seperate method
    urls.find_all do |url|
      url.host == input_url_host
    end.map do |uri|
      # Converts from URI object to string
      # Removes trailing slash
      uri.to_s.sub(%r{/\z}, '')
    end.uniq
  end
end
