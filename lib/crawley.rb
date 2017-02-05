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

    # Takes a url out of unvisited set in order to scrape and parse
    next_url = @unvisited_urls.take(1)[0]
    @unvisited_urls.subtract([next_url])

    page = HTTParty.get(next_url)
    #TODO error handling in case site is down or url invalid

    assets = Parser.new(page).asset_parse

    # adds the current (next_url) url to the visited url hash
    # with its assets
    @visited_urls[next_url] = assets

    @hrefs = Parser.new(page).href_parse
    subdomains = Subdomainer.new(@domain, @hrefs).make_subdomains

    @unvisited_urls = @unvisited_urls + (subdomains - @visited_urls.keys)
    #TODO check that the just visited url doesn't end up in the unvisited_urls

    # binding.pry
    # # binding placeholder
    # @unvisited_urls = Set[]

  end
    # 1 crawler.run takes a domain, gets the page data
    # adds domain to visited_urls list
    # 2 parses page, 
    # 3 gets unique assets, adds to results list 
    # 4 gets list of unique subdomains, adds to all_subdomains list
    # this is a set so there cant be duplicates anyway.
    # for each unique subdomain, if not in visited list, add to unvisited list
    # remove domain from unvisited list
    # 5 call run on next item in unvisited urls IF there are any 
    # otherwise return results
    # CHANGED to while instead of attempting recursion
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

class Subdomainer
  def initialize(domain, hrefs)
    @hrefs = hrefs
    @domain = domain
  end

  def make_subdomains
    domain_scheme = URI(@domain).scheme
    domain_host = URI(@domain).host
    if domain_scheme == 'http'
      domain_root = URI::HTTP.build({host: domain_host})
    else
      domain_root = URI::HTTPS.build({host: domain_host})
    end
    urls = @hrefs.map do |href|
      URI.join(domain_root, href.strip)
    end
    # Ensures that only domains with the same host are returned
    filtered_urls = Set.new(urls)
    filtered_urls.find_all do |url|
      url.host == domain_host
    end
  end
end
