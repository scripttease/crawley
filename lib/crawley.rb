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
    @visited_urls = {} # { page_url => [links_from_page] }
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
    next_url = @unvisited_urls.pop  # Get and remove a url
    page_urls = get_page_urls(next_url) # Method not written yet, 
                                        # it will do the get and HTML parsing etc

    # Add page and contained links to visited_urls
    @visited_urls[next_url] = page_urls

    # Add any new URLs to the unvisited_urls
    with_subs = add_missing_subdomains(page_urls)
    valid_urls = remove_urls_for_incorrect_domain(with_subs, @domain)
    @unvisited_urls = @unvisited_urls + (valid_urls - @visited_urls.keys)
  end
end


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
