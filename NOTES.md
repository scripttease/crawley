Crawler Challenge
=================

We would like you to write a simple (not concurrent) web crawler.
Given a starting URL, it should visit every reachable page under that domain, and should not cross subdomains. For example when crawling “www.google.com” it would not crawl “mail.google.com”.
For each page, it should determine the URLs of every static asset (images, javascript, stylesheets) on that page.
The crawler should output to STDOUT in JSON format listing the URLs of every static asset, grouped by page.
 
For example:
[
  {
    "url": "http://www.example.org",
    "assets": [
      "http://www.example.org/image.jpg",
      "http://www.example.org/script.js"
    ]
  },
  {
    "url": "http://www.example.org/about",
    "assets": [
      "http://www.example.org/company_photo.jpg",
      "http://www.example.org/script.js"
    ]
  },
  ..
]
 

1. Given a url, the crawler scrapes the page for subdomains
2. The crawler stores the subdomains in a list, the initial value for which is the 'input' url
  * In order that this is FP style the list should actually be a new list every time *provided* that the subdomain is *not* already in the list which means that it has not already been visited.
  * no this isn't right, actually there should be two lists here. The initial 'input' url makes a part of the visited list. 
  * the program searches for subdomains. when it finds one that isn't on 'visited' it goes there, gets the assets AND THEN adds the subdomain to the visited list
3. The crawler writes to a file? a list of asset urls for the page to eventually print to stdout under each subdomain url.
  * Don't want to do this as you go through or you will get duplicates... so ... normally here I would have a list that was overwritten but this seems ugly.



You may use whatever language you are most comfortable with.
You may use third party libraries for things like HTML parsing or making requests, but the overall coordination of the task must be handled by your code. An example of something you shouldn’t use is the web crawling framework Scrapy.
You should include a README with clear installation and running instructions.
 
We will assess your submission on the following key aspects:
Functionality
Code clarity & structure
Robustness
Testing
We will test your submission against gocardless.com, although it should be possible to run it against any website.
 
Please submit the challenge within a week.


> # Crawler takes a domain from run_ and gets and parses the page data
> # it gives the parsed page data to urlTracker
> #
> # after this it will call the crawler again.
> # so here there needs to be a thing that says if there are no more unvisited urls in the list you exit...

>   # how about initialising with an array of sets?
>   # that gives me lots of default args?

>   # need domain initialised simply to filter out links that are not subdomains.
>   # so could pass in directly to urlTracker?
>   # NOPE this is obvs wrong I use the domain to give to HTTParty!!!

>     # somehow, the urlTracker needs to keep hold of the last lot of subdomains
>     # This isn't possible if it is in a seperate class...
>     # so seperate code so that all the methods are working on simply single objects
>     # then one class calls those methods and accumulates the list.
>     #

>   # want to check if the link starts with http already
>   # or would otherwise throw an error?
>   # seems that URI handles this case...
> # change this into a class that does subdomaining just for each hrf
> # that way it can be called form the tracker.


> # urlTracker takes the parsed page data and decides if the url has been visited or not

> # def self.visited_pagepages(url)
> #   set = Set.new [@input_url]
> #   set.add(url)
> # end
> # asset_hash = visited_pages.each do vp {
> #   {vp: asset_array}
> # }
> # end

    > # 1 crawler.run takes a domain, gets the page data
    > # adds domain to visited_urls list
    > # 2 parses page, 
    > # 3 gets unique assets, adds to results list 
    > # 4 gets list of unique subdomains, adds to all_subdomains list
    > # this is a set so there cant be duplicates anyway.
    > # for each unique subdomain, if not in visited list, add to unvisited list
    > # remove domain from unvisited list
    > # 5 call run on next item in unvisited urls IF there are any 
    > # otherwise return results


 @page = "<!DOCTYPE html>\n<html>\n  <head>\n    <link href='https://fonts.googleapis.com/css?family=Josefin+Sans:400,400italic,600,600italic' rel='stylesheet' type='text/css'><meta charset=\"utf-8\">\n    <meta name=\"viewport\" content=\"width=device-width\">\n    <title>Scripttease</title>\n    <link rel=\"stylesheet\" href=\"/main.css\">\n    <link rel=\"icon\" type=\"image/png\" href=\"/icons/favicon-32x32.png\" sizes=\"32x32\">\n    <link rel=\"icon\" type=\"image/png\" href=\"/icons/favicon-96x96.png\" sizes=\"96x96\">\n    <link rel=\"icon\" type=\"image/png\" href=\"/icons/favicon-16x16.png\" sizes=\"16x16\">\n  </head>\n  <body>\n\n\n    <div class=\"entire-top\">\n      <div class=\"side-container\">\n        <div class=\"side-svg\" preserveAspectRatio=\"xMinYMid meet\" \n                              style=\"width: 100%; padding-bottom: 300%; height: 1px; overflow: visible\">\n          <svg class=\"raindrop-svg\" viewbox=\"0 0 150 300\">\n\n            <path class=\"raindrop1\" d=\"M15,67.5 c-6,22.5 36,22.5 30,0 l-15,-30\"/>\n              <a xlink:href=\"/about\">\n                <text id=\"about-svg\" x=\"40\" y=\"67.5\" fill=\"#820D98\">About</text>\n              </a>\n            <path class=\"raindrop2\" d=\"M15,157.5 c-6,22.5 36,22.5 30,0 l-15,-30\"/>\n              <a xlink:href=\"/posts\">\n                <text id=\"posts-svg\" x=\"40\" y=\"157.5\" fill=\"#820D98\">Posts</text>\n              </a>\n            <path class=\"raindrop3\" d=\"M15,247.5 c-6,22.5 36,22.5 30,0 l-15,-30\"/>\n              <a xlink:href=\"/projects\">\n                <text id=\"projects-svg\" x=\"40\" y=\"247.5\" fill=\"#820D98\">Projects</text>\n              </a>\n          </svg>\n        </div>\n      </div>\n\n      <div class=\"banner-container\">\n        <div class=\"scaling-svg-container\" preserveAspectRatio=\"xMidYMid slice\" style=\"width: 100%; padding-bottom: 39%; /* 100% * 310/790 */ height: 1px; overflow: visible\">\n\n          <a href=\"/\">\n            <svg id=\"rc1\" class=\"scaling-svg\" viewBox=\"0 0 790 310\">\n\n              <path class=\"svg-s\" d=\"m75,75 c-29,-78 -99,27 -15,61 s-6,178 -47,62\"/> \n              <path class=\"svg-c\" d=\"M160,150 c-36,-69 -104,140 1,72\"/>\n              <path class=\"svg-r-a\" d=\"M185,180 c-17,-65 23,-54 7,50\"/>\n              <path class=\"svg-r-b\" d=\"M192,230 C184,136 243,136 251,160\"/>\n              <path class=\"svg-i\" d=\"M267,167 c-07,-09 23,-69 7,65\"/>\n              <path class=\"svg-dot\" d=\"M278,135 C299,121 249,106 276,135\"/>\n              <path class=\"svg-p-a\" d=\"M310,180 c-17,-65 23,-59 7,110 \"/>\n              <path class=\"svg-p-b\" d=\"M322,155 C379,102 385,290 321,212\"/>\n              <path class=\"svg-t\" d=\"M405,90 c-30,157 -9,161 20,125 \"/>\n              <path class=\"svg-t-bar\" d=\"M373,131 l45,-12\"/>\n              <path class=\"svg-ttwo\" d=\"M460,94 c-40,148 -9,169 23,112 \"/>\n              <path class=\"svg-ttwo-bar\" d=\"M430,135 l5"
