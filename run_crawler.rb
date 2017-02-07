#!/usr/bin/env ruby

require 'json'
require_relative 'lib/crawley.rb'

#TODO add code coverage metrics and CLI

puts 'Enter URL you wish to crawley'
# #TODO remove hardcoded test urls

# domain = 'https://scripttease.uk/'
# domain = 'https://gocardless.com/users/registrations/membership_options'
domain = 'https://gocardless.com/'

# Removes trailing slash from input url
# This will ensure no urls visited twice by being same but having trailing slach or not.
# Need to also remove all trailing '.html' so that not visited twice 
# Must also do this on the #prefix_hrefs method
domain = domain.sub(%r{/\z}, '')
# domain = gets.chomp.sub(%r{/\z}, '')

results = Crawler.new(domain).run!

puts JSON.pretty_generate(results)
