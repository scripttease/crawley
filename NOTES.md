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
