# File-Name:        calendar-heatmap.R
# Date:             2015-09-14
# Author:           Artem Klevtsov
# Email:            a.a.klevtsov@gmail.com
# Purpose:          Create a calendar users activity heatmap with the Google Analytics data
# Data Used:
# Packages Used:    RGA, stringi, ggplot2
# Output File:      calendar-heatmap.png
# Data Output:
# Machine:          x86_64 GNU/Linux
# License:          CC BY 4.0

## Params
id <- 7783180 # Profile (View) ID
year <- 2014 # Year
locale <- "en_US" # Locale
firstday <- "Sunday" # First day of week
metric <- "ga:sessions" # GA metric

## Load pakcages
library(RGA)
library(stringi)
library(ggplot2)

# Locale specific names
moths <- stri_datetime_symbols(locale = locale, width = "abbreviated")$Month
days <- stri_datetime_symbols(locale = locale, width = "abbreviated")$Weekday

## Authorisation
authorize()

## Get data
ga_data <- get_ga(profile.id = id,
                  start.date = paste0(year, "-01-01"),
                  end.date = paste0(year, "-12-31"),
                  metrics = metric,
                  dimensions = "ga:month,ga:day,ga:dayOfWeek,ga:week",
                  filters = "ga:sessions > 0")

## Prepare data
ga_data$month <- factor(ga_data$month, levels = 1:12, labels = moths)
ga_data$day.of.week <- factor(ga_data$day.of.week, levels = 0:6, labels = days)

# If Monday is first day of week
if (firstday == "Monday") {
    ga_data$day.of.week <- factor(ga_data$day.of.week, levels(ga_data$day.of.week)[c(2:7, 1)])
    ga_data[as.numeric(ga_data$day.of.week) == 7, "week"] <- ga_data[as.numeric(ga_data$day.of.week) == 7, "week"] - 1
}

## Make plot
p <- ggplot(ga_data, aes(x = day.of.week, y = week)) +
    geom_tile(aes_string(fill = gsub("ga:", "", metric)), colour = "white") +
    geom_text(aes(label = day)) +
    facet_wrap(~ month, ncol = 3, scales = "free") +
    scale_fill_gradient(low = "steelblue4", high = "red") +
    labs(title = "Calendar heatmap users activity", x = NULL, y = NULL) +
    scale_y_reverse(breaks = NULL)

if (interactive()) {
    # Print plot
    print(p)
} else {
    ## Save plot
    png(filename = "plots/calendar-heatmap.png", res = 300, width = par("din")[1], height = par("din")[2], units = "in")
    print(p)
    dev.off()
}
