#!/usr/bin/env ruby
gem 'minitest', '>= 5.0.0'
require 'minitest/autorun'
require 'minitest/pride'
require 'set'
require_relative 'crawley'

class CrawlerTest < Minitest::Test
  def test_visited_pages_set_contains_input_url
    url = 'www.url.com'
    assert_equal Set['http://www.input.com', 'www.url.com'], Crawler.visited_pages(url)
    #TODO stdin is entered manually! Change this
  end
end

