#!/usr/bin/env ruby

require 'httparty'
require 'nokogiri'
require 'json'
require 'pry'
require 'csv'
require 'set'
require 'uri'


class Crawler
  def initialize(domain, visited_urls = Set.new)
    @domain = domain
    @visited_urls = visited_urls
  end

  def run!
    page = HTTParty.get(@domain)
    #TODO error handling in case site is down or url invalid

    @visted_urls = UrlTracker.new(@visited_urls).mark_as_visited(@domain)

    @hrefs = HrefParser.new(page).href_parse

    @subdomains = Subdomainer.new(@domain, @hrefs).make_subdomains

    @unvisited_urls

    @next_domain = UrlTracker.new(@subdomains)

    if @unvisited_urls.any?
      Crawler.new(@unvisited_urls.first, @visited_urls).run!
    else
      @results
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
  # TODO fix problem that at hte moment all of the data like unvisited and results disappears when crawler is called on the next url in the list
end

class HrefParser
  def initialize(page)
    @parsed_page = Nokogiri::HTML(page)
  end

  def href_parse
    href_elems = @parsed_page.css('a[href]')
    href_elems.map do |elem|
      elem.attributes["href"].value
    end
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
    # binding.pry
  end
end

class UrlTracker
  def initialize(url_set)
    @url_set = url_set
  end

  def add_url(url)
    # new url add to pages
  end

  def mark_as_visited(url)
    @url_set.add(url) 
  end

  def all_urls
    # All urls
  end

  def visited_urls
    # All visited urls
  end

  def unvisited_urls
    # All unvisited urls
  end
end

# this takes the parsed page data and extracts all the assets and adds them to the asset set (if it is a set there can't be duplicates so no need to check)
#
class AssetTracker
  def initialise(parsed_page)
    @parsed_page = parsed_page
  end

end


