#!/usr/bin/env ruby
gem 'rspec'
require 'rspec'
require 'set'
require 'uri'
require_relative '../lib/crawley'

RSpec.describe Subdomainer do
  before :example do 
    @domain = 'http://scripttease.uk'
    # @page = 'blah'
    # @parser = Parser.new(@page)
  end

  describe '#make_subdomains' do

    it 'returns valid subdomains from href array ' do
      hrefs = [
        "/",
        " /2016/06/12/you-git.html",
        "how-i-made-a-jekyll-website.html",
      ]
      expect(Subdomainer.new(@domain, hrefs).make_subdomains).to eq [
        'http://scripttease.uk/',
        'http://scripttease.uk/2016/06/12/you-git.html',
        'http://scripttease.uk/how-i-made-a-jekyll-website.html',
      ].map {|u| URI(u) }
    end

    it 'only joins the domain prefix if it is absent' do
      hrefs = [
        "how-i-made-a-jekyll-website.html",
        "http://scripttease.uk/about",
      ]
      expect(Subdomainer.new(@domain, hrefs).make_subdomains).to eq [
        'http://scripttease.uk/how-i-made-a-jekyll-website.html',
        "http://scripttease.uk/about",
      ].map {|u| URI(u) }
    end

    it 'does not add duplicates to the list' do
      #TODO if there are trailing slashes or .html the url is still valid
      # but the code cannot differentiate.
      hrefs = [
        "how-i-made-a-jekyll-website.html",
        "how-i-made-a-jekyll-website.html",
        "http://scripttease.uk/about/",
        "http://scripttease.uk/about/"
      ]
      expect(Subdomainer.new(@domain, hrefs).make_subdomains).to eq [
        'http://scripttease.uk/how-i-made-a-jekyll-website.html',
        "http://scripttease.uk/about/"
      ].map {|u| URI(u) }
    end

    it 'only adds subdomains' do
      hrefs = [
        "http://scripttease.uk/about/",
        "http://twitter.uk/scripttease/",
      ]
      expect(Subdomainer.new(@domain, hrefs).make_subdomains).to eq [
        "http://scripttease.uk/about/"
      ].map {|u| URI(u) }
    end
  end
end
