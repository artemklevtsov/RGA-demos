# File-Name:        weekly-bar.R
# Date:             2015-09-14
# Author:           Artem Klevtsov
# Email:            a.a.klevtsov@gmail.com
# Purpose:          Create a daily users activity heatmap with the Google Analytics data
# Data Used:
# Packages Used:    RGA, stringi, ggplot2
# Output File:      weekly-bar.png
# Data Output:
# Machine:          x86_64 GNU/Linux
# License:          CC BY 4.0

## Params
id <- 7783180 # Profile (View) ID
year <- 2014 # Year
locale <- "en_US" # Locale
firstday <- "Sunday" # First day of week
metric <- "ga:pageviews" # GA metric

## Load pakcages
library(RGA)
library(ggplot2)
library(stringi)

# Locale specific names
days <- stri_datetime_symbols(locale = locale, width = "abbreviated")$Weekday

## Authorisation
authorize()

## Setup dates range
# Get first date
first <- firstdate(id)
if (firstday == "Sunday") {
    start.date <- as.Date(cut(first, "weeks")) + 6 # Get the next sunday
    end.date <- as.Date(cut(Sys.Date(), "weeks")) - 2 # Get the last sunday
} else if (firstday == "Monday") {
    start.date <- as.Date(cut(first, "weeks")) + 7 # Get the next monday
    end.date <- as.Date(cut(Sys.Date(), "weeks")) - 1 # Get the last saturday
}

## Get data
ga_data <- get_ga(profile.id = id, start.date = start.date, end.date = end.date,
                  metrics = metric, dimensions = "ga:dayOfWeek")

## Prepare data
ga_data$day.of.week <- factor(ga_data$day.of.week, levels = 0:6, labels = days)
# If Monday is first day of week
if (firstday == "Monday") {
    ga_data$day.of.week <- factor(ga_data$day.of.week, levels(ga_data$day.of.week)[c(2:7, 1)])
    ga_data[as.numeric(ga_data$day.of.week) == 7, "week"] <- ga_data[as.numeric(ga_data$day.of.week) == 7, "week"] - 1
}


## Draw plot
p <- ggplot(ga_data, aes_string(x = "day.of.week", y = gsub("ga:", "", metric))) +
    geom_bar(stat = "identity") +
    labs(title = "Weekly users activity")

if (interactive()) {
    # Print plot
    print(p)
} else {
    ## Save plot
    png(filename = "plots/weekly-bar.png", res = 300, width = par("din")[1], height = par("din")[2], units = "in")
    print(p)
    dev.off()
}
