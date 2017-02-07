Crawley
=======

### A web Crawler which scrapes a given domain and returns its assets along withh the assets of all accessible domains with the same host.

#### You can enter the domain you wish to crawl into STDIN and the results will be printed in JSON format to STDOUT

##Usage:

Install dependencies:

```sh
gem install bundler
bundle install
```

Run crawler:

```sh
ruby run_crawler.rb
> Enter the domain you wish to crawley
>
```

Example:

```sh
ruby run_crawler.rb
> Enter the domain you wish to crawley
> 'https://scripttease.uk/'

Scraping https://scripttease.uk
Scraping https://scripttease.uk/2016/06/12/you-git.html
Scraping https://scripttease.uk/2016/06/07/javascript-in-all-its-glory.html
Scraping https://scripttease.uk/2016/06/05/the-trials-and-tribulations-of-a-baby-dev.html
Scraping https://scripttease.uk/2016/05/26/how-i-made-a-jekyll-website.html
{
  "https://scripttease.uk": [
    "/rainbow-rain.js",
    "https://fonts.googleapis.com/css?family=Josefin+Sans:400,400italic,600,600italic",
    "/main.css",
    "/icons/favicon-32x32.png",
    "/icons/favicon-96x96.png",
    "/icons/favicon-16x16.png"
  ],
  "https://scripttease.uk/2016/06/12/you-git.html": [
    "/rainbow-rain.js",
    "https://fonts.googleapis.com/css?family=Josefin+Sans:400,400italic,600,600italic",
    "/main.css",
    "/icons/favicon-32x32.png",
    "/icons/favicon-96x96.png",
    "/icons/favicon-16x16.png"
  ],
  "https://scripttease.uk/2016/06/07/javascript-in-all-its-glory.html": [
    "/rainbow-rain.js",
    "https://assets.github.com/images/icons/emoji/unicode/1f49c.png",
    "https://fonts.googleapis.com/css?family=Josefin+Sans:400,400italic,600,600italic",
    "/main.css",
    "/icons/favicon-32x32.png",
    "/icons/favicon-96x96.png",
    "/icons/favicon-16x16.png"
  ],
  "https://scripttease.uk/2016/06/05/the-trials-and-tribulations-of-a-baby-dev.html": [
    "/rainbow-rain.js",
    "https://fonts.googleapis.com/css?family=Josefin+Sans:400,400italic,600,600italic",
    "/main.css",
    "/icons/favicon-32x32.png",
    "/icons/favicon-96x96.png",
    "/icons/favicon-16x16.png"
  ],
  "https://scripttease.uk/2016/05/26/how-i-made-a-jekyll-website.html": [
    "/rainbow-rain.js",
    "https://fonts.googleapis.com/css?family=Josefin+Sans:400,400italic,600,600italic",
    "/main.css",
    "/icons/favicon-32x32.png",
    "/icons/favicon-96x96.png",
    "/icons/favicon-16x16.png"
  ]
}

```
