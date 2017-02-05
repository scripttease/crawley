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
