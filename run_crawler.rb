#!/usr/bin/env ruby

require 'json'
require_relative 'lib/crawley.rb'

# TODO: add code coverage metrics and CLI

puts 'Enter URL you wish to Crawley'

# #TODO remove hardcoded test urls
# input_url = 'https://scripttease.uk/'
# input_url = 'https://gocardless.com/'
# input_url = input_url.sub(%r{/\z}, '')

# TODO: Need to also remove all trailing '.html' so that not visited twice
# Must also do this on the #prefix_hrefs method
input_url = gets.chomp.sub(%r{/\z}, '')

begin
  input_url = URI.parse(input_url)
rescue URI::InvalidURIError
  puts 'The URL you have entered is not valid, please try again'
  input_url = gets.chomp.sub(%r{/\z}, '')
end

input_url = ('https://' + input_url.path) unless input_url.scheme

input_url.to_s

results = Crawler.new(input_url).run!

puts JSON.pretty_generate(results)
# TODO: Catch where scheme not given but input_url is actually http not https
# Could implement this by saying if results assets are empty try https.
# If results are STILL empty, return "This URL appears to have no links or static assets, perhaps it is invalid, check and try again"
# Then return the prompt.
#
# TODO write results to file?
