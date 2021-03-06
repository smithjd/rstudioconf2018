#' ---
#' output: github_document
#' author: John David Smith
#' date: "`r Sys.Date()`"
#' ---
#'
library(tidyverse)
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

saveRDS(all_tweets_all_columns, paste0(hashtag, Sys.Date(), ".Rds"))

all_tweets_some_columns <- all_tweets_all_columns %>%
  select(created_at, screen_name, text, urls_expanded_url, favorite_count, retweet_count)

# Investigate with
# datatable(all_tweets_some_columns)
all_tweets_some_columns %>%
  arrange(desc(favorite_count)) %>%
  mutate(text = str_sub(text, 1, 60)) %>%
  select(screen_name, retweet_count, text)

popular_urls  <- all_tweets_some_columns %>% filter(!is.na(urls_expanded_url), retweet_count > 10) %>% unnest()

popular_urls %>%
  arrange(desc(retweet_count)) %>%
  select(screen_name, retweet_count, urls_expanded_url)

# datatable(popular_urls)

write_csv(popular_urls, paste0("urls_in_", hashtag, "_as_of_", Sys.Date(), ".csv"))
