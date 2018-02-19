get-twitter-tweets.R
================
John David Smith
2018-02-19

``` r
library(tidyverse)
```

    ## ── Attaching packages ──────────

    ## ✔ ggplot2 2.2.1.9000     ✔ purrr   0.2.4     
    ## ✔ tibble  1.4.2          ✔ dplyr   0.7.4     
    ## ✔ tidyr   0.8.0          ✔ stringr 1.3.0     
    ## ✔ readr   1.1.1          ✔ forcats 0.3.0

    ## ── Conflicts ───────────────────
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(rtweet)
library(DT)

hashtag <- "rstudioconf"

# Now pick up the tweets containing the hashtag, inspect, and save

#  Retrieve current tweets
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

    ## # A tibble: 82 x 3
    ##    screen_name  retweet_count text                                        
    ##    <chr>                <int> <chr>                                       
    ##  1 dataandme               56 "ICYMI, 🚫🐜 @ajmcoqui's \"Debugging in RStud…
    ##  2 seanjtaylor             21 "I had serious FOMO missing #rstudioconf be…
    ##  3 dataandme               26 "ICYMI, slides 📽 from my talk, \"contributi…
    ##  4 ZazzValette              9 We met at #rstudioconf in San Diego and are…
    ##  5 dataandme                9 💙 seeing how @EmilyRiederer uses in-house #…
    ##  6 smithjd                 17 Riffing on @hadleywickham's data science mo…
    ##  7 grrrck                  15 Some #rstats weekend fun. I was inspired by…
    ##  8 Denironyx               13 Beginner workshop on #rstats and @rstudio. …
    ##  9 CMastication            11 Let’s talk about Imposter Syndrome (thread)…
    ## 10 dataandme                7 "ICYMI, 📽 Max Kuhn's deck from #rstudioconf…
    ## # ... with 72 more rows

``` r
popular_urls  <- all_tweets_some_columns %>% filter(!is.na(urls_expanded_url), retweet_count > 10) %>% unnest()

popular_urls %>%
  arrange(desc(retweet_count)) %>%
  select(screen_name, retweet_count, urls_expanded_url)
```

    ## # A tibble: 8 x 3
    ##   screen_name  retweet_count urls_expanded_url                            
    ##   <chr>                <int> <chr>                                        
    ## 1 dataandme               56 https://buff.ly/2HmcL2L                      
    ## 2 dataandme               26 http://buff.ly/2Ee08F4                       
    ## 3 seanjtaylor             21 https://twitter.com/DynamicWebPaige/status/9…
    ## 4 Rbloggers               19 https://wp.me/pMm6L-FhY                      
    ## 5 smithjd                 17 http://learningalliances.net/2018/02/computi…
    ## 6 grrrck                  15 http://garrickadenbuie.com/project/ggpomolog…
    ## 7 theRcast                15 http://r-podcast.org/24                      
    ## 8 CMastication            11 https://twitter.com/academicbatgirl/status/9…

``` r
# datatable(popular_urls)

write_csv(popular_urls, paste0("urls_in_", hashtag, "_as_of_", Sys.Date(), ".csv"))
```
