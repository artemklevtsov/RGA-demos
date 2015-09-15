## Load pakcages
library(RGA)
library(wordcloud)
library(RColorBrewer)

## Authorisation
authorize()

## Get Profile ID
# Profiles (profiles) list
profiles <- list_profiles()
# Site URL
site_url <- "balancer.ru"
# Get Profile ID
id <- profiles[profiles$website.url == site_url, "id"]

## Setup dates range
# Set first date
start.date <- "2014-01-01"
# Set the last date
end.date <- "2014-12-31"

## Get data
ga_data <- get_ga(id, start.date = start.date, end.date = end.date,
                  metrics = "ga:sessions", dimensions = "ga:keyword",
                  filters = "ga:medium==organic && ga:keyword!=(not provided) && ga:keyword!=(not set) && ga:keyword!=(other)",
                  sort = "-ga:sessions", max.results = 100)

## Prepare data
ga_data$keyword <- tolower(ga_data$keyword)

## Draw plot
pal <- brewer.pal(8, "Dark2")
## Save plot
png(filename = "plots/word-cloud.png", res = 300, width = par("din")[1], height = par("din")[2], units = "in")
wordcloud(ga_data$keyword, ga_data$sessions, random.order = FALSE, rot.per = 0.15, colors = pal)
dev.off()

