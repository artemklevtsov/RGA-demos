# File-Name:        trafic-sources.R
# Date:             2015-09-14
# Author:           Artem Klevtsov
# Email:            a.a.klevtsov@gmail.com
# Purpose:          Create a trafic sources area plot with the Google Analytics data
# Data Used:
# Packages Used:    RGA, ggplot2
# Output File:      trafic-sources.png
# Data Output:
# Machine:          x86_64 GNU/Linux
# License:          CC BY 4.0

## Params
id <- 7783180 # Profile (View) ID
year <- 2014 # Year
locale <- "en_US" # Locale

## Load pakcages
library(RGA)
library(ggplot2)

# Locale specific names
moths <- stri_datetime_symbols(locale = locale, width = "abbreviated")$Month

## Authorisation
authorize()

## Get data
ga_data <- get_ga(profile.id = id,
                  start.date = paste0(year, "-01-01"),
                  end.date = paste0(year, "-12-31"),
                  metrics = "ga:sessions", dimensions = "ga:month,ga:medium",
                  filters = "ga:sessions > 1 && ga:medium != (not set)")

## Prepare data
ga_data$month <- factor(ga_data$month, levels = 1:12, labels = moths)
ga_data[ga_data$medium == "(none)", "medium"] <- "direct"

## Draw plot
p <- ggplot(data = ga_data, aes(x = month, y = sessions, fill = medium, group = medium)) +
    geom_area(position = "stack") +
    labs(title = "Trafic sources comparison", x = "") +
    theme(legend.position = "bottom")

if (interactive()) {
    # Print plot
    print(p)
} else {
    ## Save plot
    png(filename = "plots/traffic-sources.png", res = 300, width = par("din")[1], height = par("din")[2], units = "in")
    print(p)
    dev.off()
}
