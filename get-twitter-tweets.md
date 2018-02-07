Get Tweets for the Rstudio Conf 2018
================
John David Smith
2018-02-06

``` r
library(tidyverse)
```

    ## ── Attaching packages ──────────────────────────────────────────────────────────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 2.2.1.9000     ✔ purrr   0.2.4     
    ## ✔ tibble  1.3.4          ✔ dplyr   0.7.4     
    ## ✔ tidyr   0.7.2          ✔ stringr 1.2.0     
    ## ✔ readr   1.1.1          ✔ forcats 0.2.0

    ## ── Conflicts ─────────────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(purrr)
library(rtweet)
library(RCurl)
```

    ## Loading required package: bitops

    ## 
    ## Attaching package: 'RCurl'

    ## The following object is masked from 'package:tidyr':
    ## 
    ##     complete

``` r
library(repurrrsive)
library(stringr)
library(DT)

hashtag <- "rstudioconf"
```

Now pick up the tweets containing the hashtag, inspect, and save

``` r
all_tweets_all_columns <- search_tweets(
  hashtag,
  n = 30000, 
  retryonratelimit = TRUE, 
  include_rts = FALSE
)
```

    ## Searching for tweets...

    ## This may take a few seconds...

    ## Finished collecting tweets!

    ## Searching for tweets...

    ## This may take a few seconds...

    ## Finished collecting tweets!

``` r
saveRDS(all_tweets_all_columns, paste0(hashtag, Sys.Date(), ".Rds"))

all_tweets_some_columns <- all_tweets_all_columns %>%
  select(created_at, screen_name, text, urls_expanded_url, favorite_count, retweet_count) 

# Investigate with
# datatable(all_tweets_some_columns)
all_tweets_some_columns %>% 
  arrange(desc(favorite_count)) %>% 
  mutate(text = str_sub(text, 1, 60)) %>% 
  select(screen_name, retweet_count, text) 
```

    ## # A tibble: 1,749 x 3
    ##      screen_name retweet_count
    ##            <chr>         <int>
    ##  1      AmeliaMN           218
    ##  2          drob           130
    ##  3     kearneymw           202
    ##  4    juliasilge           107
    ##  5    JennyBryan            76
    ##  6     thmscwlls            77
    ##  7 hadleywickham            19
    ##  8  datapointier            63
    ##  9          drob            72
    ## 10          drob            47
    ## # ... with 1,739 more rows, and 1 more variables: text <chr>

``` r
popular_urls  <- all_tweets_some_columns %>% filter(!is.na(urls_expanded_url), retweet_count > 10) %>% unnest()

popular_urls %>% 
  arrange(desc(retweet_count)) %>% 
  select(screen_name, retweet_count, urls_expanded_url) 
```

    ## # A tibble: 70 x 3
    ##    screen_name retweet_count
    ##          <chr>         <int>
    ##  1    AmeliaMN           218
    ##  2   kearneymw           202
    ##  3   kearneymw           202
    ##  4   kearneymw           202
    ##  5   kearneymw           202
    ##  6   kearneymw           202
    ##  7   kearneymw           202
    ##  8  juliasilge           107
    ##  9     rstudio           104
    ## 10  JennyBryan            76
    ## # ... with 60 more rows, and 1 more variables: urls_expanded_url <chr>

``` r
# datatable(popular_urls)

write_csv(popular_urls, paste0("urls_in_", hashtag, "_as_of_", Sys.Date(), ".csv"))
```
