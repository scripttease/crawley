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

  private

  def scrape_next_url!
    # Takes a url out of unvisited set in order to scrape and parse
    next_url = @unvisited_urls.take(1)[0]
    @unvisited_urls.subtract([next_url])

    puts "Scraping #{next_url}"

    page = HTTParty.get(next_url)
    #TODO error handling in case site is down or url invalid

    assets = Parser.new(page).asset_parse

    # adds the current (next_url) url to the visited url hash
    # with its assets
    @visited_urls[next_url] = assets

    @hrefs = Parser.new(page).href_parse
    subdomains = UrlManager.new(@domain, @hrefs).prefix_hrefs

    # binding.pry
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

  def asset_parse
    link_elems = @parsed_page.css('link[href]')
    link_elems.map do |elem|
      elem.attributes["href"].value
    end
    # TODO img[src], script[src]
    # and add hosts
  end
end

class UrlManager
  def initialize(domain, hrefs)
    @hrefs = hrefs
    @domain = domain
  end

  def fragment_filter(hrefs)
    # filters out hrefs that are in-page anchors
    hrefs.select do |href|
      href.split(//).first != '#'
    end
  end

  def prefix_hrefs
    domain_scheme = URI(@domain).scheme
    domain_host = URI(@domain).host
    if domain_scheme == 'http'
      domain_root = URI::HTTP.build({host: domain_host})
    else
      domain_root = URI::HTTPS.build({host: domain_host})
    end
    valid_hrefs = fragment_filter(@hrefs)
    urls = valid_hrefs.map do |href|
      begin
        URI.join(domain_root, href.strip)
      rescue URI::InvalidURIError
        nil
      end
    end.compact
    # Ensures that only domains with the same host are returned
    # TODO extract into seperate method
    filtered_urls = Set.new(urls)
    filtered_urls.find_all do |url|
      url.host == domain_host
    end
  end
end
