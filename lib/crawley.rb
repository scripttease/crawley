#!/usr/bin/env ruby

require 'httparty'
require 'nokogiri'
require 'json'
require 'pry'
require 'csv'
require 'set'
require 'uri'

class Crawler
  def initialize(domain)
    @domain = domain
    @visited_urls = {} # { visited_url => [static_assets], ...}
    @unvisited_urls = Set.new([domain])
  end

  def run!
    while @unvisited_urls.any?
      scrape_next_url!
    end
    @visited_urls
  end

  def scrape_next_url!
    page = HTTParty.get(@domain)
    #TODO error handling in case site is down or url invalid

    # Takes a url out of unvisited set in order to scrape and parse
    next_url = @unvisited_urls.take(1)
    @unvisited_urls.subtract(1)
    # TODO extract to method to test always removes same one

    assets = Parser.new(page).asset_parse

    # adds the current (next_url) url to the visited url hash
    # with its assets
    @visted_urls[next_url] = assets

    @hrefs = Parser.new(page).href_parse
    subdomains = Subdomainer.new(@domain, @hrefs).make_subdomains

    @unvisited_urls = @unvisited_urls + (subdomains - @visited_urls.keys)
    #TODO check that the just visited url doesn't end up in the unvisited_urls
  end
end

class Parser
  def initialize(page)
    @parsed_page = Nokogiri::HTML(page)
  end

  def href_parse
    href_elems = @parsed_page.css('a[href]')
    href_elems.map do |elem|
      elem.attributes["href"].value
    end
  end

  def asset_parse(page)
    # link, img, script
  end
end

class Subdomainer
  def initialize(domain, hrefs)
    @hrefs = hrefs
    @domain = domain
  end

  def make_subdomains
    urls = @hrefs.map do |href|
      URI.join(@domain, href.strip)
    end
    filtered_urls = Set.new(urls)
    filtered_urls.find_all do |url|
      url.host == URI(@domain).host
    end
  end
end
