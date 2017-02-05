#!/usr/bin/env ruby

require 'json'
require_relative 'lib/crawley.rb'

puts 'Enter URL you wish to crawley'

# domain = 'https://scripttease.uk/ok'
# domain = 'https://gocardless.com/users/registrations/membership_options'
domain = 'https://gocardless.com/'
# domain = gets.chomp

results = Crawler.new(domain).run!

# binding.pry
puts JSON.pretty_generate(results)


# crawler takes the initial domain and returns the assets and subdomains in results

