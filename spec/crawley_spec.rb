#!/usr/bin/env ruby

require 'rspec'
require 'set'
require_relative '../lib/crawley'

RSpec.describe UrlManager do
  before :example do 
    @domain = 'http://scripttease.uk'
    # @page = 'blah'
    # @parser = Parser.new(@page)
  end

  describe '#prefix_hrefs' do

    it 'returns valid subdomains from href array ' do
      hrefs = [
        '/',
        ' /2016/06/12/you-git.html',
        'how-i-made-a-jekyll-website.html',
      ]
      expect(UrlManager.new(@domain, hrefs).prefix_hrefs).to eq [
        'http://scripttease.uk',
        'http://scripttease.uk/2016/06/12/you-git.html',
        'http://scripttease.uk/how-i-made-a-jekyll-website.html',
      ]
    end

    it 'only joins the domain prefix if it is absent' do
      hrefs = [
        'how-i-made-a-jekyll-website.html',
        'http://scripttease.uk/about',
      ]
      expect(UrlManager.new(@domain, hrefs).prefix_hrefs).to eq [
        'http://scripttease.uk/how-i-made-a-jekyll-website.html',
        'http://scripttease.uk/about',
      ]
    end

    it 'does not add duplicates to the list' do
      #TODO if url has a trailing / or .html, the url is still valid
      # but the code cannot differentiate, so duplicates like this are possible.
      hrefs = [
        'how-i-made-a-jekyll-website.html',
        'how-i-made-a-jekyll-website.html',
        'http://scripttease.uk/about/',
        'http://scripttease.uk/about/'
      ]
      expect(UrlManager.new(@domain, hrefs).prefix_hrefs).to eq [
        'http://scripttease.uk/how-i-made-a-jekyll-website.html',
        'http://scripttease.uk/about'
      ]
    end

    it 'only adds subdomains' do
      hrefs = [
        'http://scripttease.uk/about/',
        'http://twitter.uk/scripttease/',
      ]
      expect(UrlManager.new(@domain, hrefs).prefix_hrefs).to eq [
        'http://scripttease.uk/about'
      ]
    end
  end

  describe '#fragment_filter' do
    it 'filters out hrefs that start with #' do
      hrefs = [
        'how-i-made-a-jekyll-website.html',
        '#how-i-made-a-jekyll-website.html',
      ]
      expect(UrlManager.new(@domain, hrefs).fragment_filter(hrefs)).to eq [
        'how-i-made-a-jekyll-website.html',
      ]
    end
  end
end

RSpec.describe Crawler do
  before :example do 
    @domain = 'http://scripttease.uk'
  end

  describe '#run!' do
    #TODO stub page or mock HTTParty
    xit 'calls scrape_next_url! ONLY if @unvisited_urls set is empty' do
      expect(Crawler.new(@domain).run!).to eq {}
    end
  end
end

RSpec.describe Parser do

  describe '#href_parser' do
    before :example do 
      @page = "<link href='https://fonts.googleapis.com/css?family=Josefin+Sans:400,400italic,600,600italic' rel='stylesheet' type='text/css'>"
    end

    it 'Returns array of href values for css selector[attribute]' do
      selector_attr = 'link[href]'
      attrb = 'href'
      expect(Parser.new(@page).href_parser(selector_attr, attrb)).to eq ['https://fonts.googleapis.com/css?family=Josefin+Sans:400,400italic,600,600italic']
    end
  end

  #TODO Use alternative string notation here so can consisitently use " not '
  describe '#href_parse' do
    before :example do 
      @page = "<a href='/how-i-made-a-jekyll-website.html'>More</a>"
    end

    it 'Returns array of href values for css selector a[href]' do
      expect(Parser.new(@page).href_parse).to eq ['/how-i-made-a-jekyll-website.html']
    end
  end

  describe '.asset_link_filter' do
    it 'Remove page url links from assets array' do
      expect(Parser.new(@page).asset_link_filter(['https://fonts.googleapis.com/css?family=Josefin+Sans:400,400italic,600,600italic', 'http://scripttease.uk/how-i-made-a-jekyll-website/'])).to eq ['https://fonts.googleapis.com/css?family=Josefin+Sans:400,400italic,600,600italic']
    end
  end
  #TODO Spec .asset_parser, .asset_parser?
end
