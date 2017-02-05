#!/usr/bin/env ruby

require 'httparty'
require 'nokogiri'
require 'json'
require 'pry'
require 'csv'
require 'set'
require 'uri'

# urlTracker takes the parsed page data and decides if the url has been visited or not
# after this it will call the crawler again.
# so here there needs to be a thing that says if there are no more unvisited urls in the list you exit...

class UrlTracker
  def initialize(subdomains)
    @subdomains = subdomains
  end

  def add_url(url)
    # new url add to pages
    # huh???
  end

  def mark_as_visited(url)
    # Record the given url as being visited
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

# Crawler takes a domain from run_ and gets and parses the page data
# it gives the parsed page data to urlTracker
#
class Crawler
  def initialize(domain)
    @domain = domain
    # @urlTracker = urlTracker.new(domain)
  end

  # need domain initialised simply to filter out links that are not subdomains.
  # so could pass in directly to urlTracker?
  # NOPE this is obvs wrong I use the domain to give to HTTParty!!!

  def run!
    page = HTTParty.get(@domain)

    #TODO error handling in case site is down etc
    #or domain is invalid etc (as this method will be called with the subdomains)

    @hrefs = HrefParser.new(page).href_parse
    @subdomains = Subdomainer.new(@domain, @hrefs).make_subdomains
    UrlTracker.new(@subdomains)
  end
end

class HrefParser
  def initialize(page)
    # @page = page
    @parsed_page = Nokogiri::HTML(page)
    # @domain = domain
  end

  def href_parse
    # @parsed_page = Nokogiri::HTML(page)
    href_elems = @parsed_page.css('a[href]')
    hrefs = href_elems.map do |elem|
      elem.attributes["href"].value
    end
    # make_subdomains(hrefs)
  end
end

class Subdomainer
  def initialize(domain, hrefs)
    @hrefs = hrefs
    @domain = domain
  end

  # want to check if the link starts with http already
  # or would otherwise throw an error?
  def make_subdomains
    urls = @hrefs.map do |href|
      URI.join(@domain, href.strip)
    end
    filtered_urls = Set.new(urls)
    subdomains = filtered_urls.find_all do |url|
      url.host == URI(@domain).host
    end
    # binding.pry
    # subdomains.all
  end
end



# this takes the parsed page data and extracts all the assets and adds them to the asset set (if it is a set there can't be duplicates so no need to check)
#
class AssetTracker
  def initialise(parsed_page)
    @parsed_page = parsed_page
  end

end

# def self.visited_pagepages(url)
#   set = Set.new [@input_url]
#   set.add(url)
# end
# asset_hash = visited_pages.each do vp {
#   {vp: asset_array}
# }
# end

