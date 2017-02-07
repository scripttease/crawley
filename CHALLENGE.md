Crawler Challenge
=================

Write a simple (not concurrent) web crawler.
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

You may use whatever language you are most comfortable with.
You may use third party libraries for things like HTML parsing or making requests, but the overall coordination of the task must be handled by your code. An example of something you shouldn’t use is the web crawling framework Scrapy.
You should include a README with clear installation and running instructions.
 
We will assess your submission on the following key aspects:
Functionality
Code clarity & structure
Robustness
Testing
It should be possible to run it against any website.
