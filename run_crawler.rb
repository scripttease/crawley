#!/usr/bin/env ruby

require 'json'
require_relative 'lib/crawley.rb'

puts 'Enter URL you wish to crawley'

domain = 'https://www.sitepoint.com/guide-ruby-collections-ii-hashes-sets-ranges/'
# domain = gets.chomp

results = Crawler.new(domain, visited_urls).run!

puts results.to_json


# crawler takes the initial domain and returns the assets and subdomains in results

