
library(lubridate)
library(dplyr)
library(readr)

## Defining the internet source for the download
source <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

## Downloading zipped files in Data folder
if (!file.exists("./Data")) {
    dir.create("./Data")
}
    download.file(url = source, destfile = "./Data/Exploratory_data_analysis.zip")

## Unzip the zipped files
unzip(zipfile = "./Data/Exploratory_data_analysis.zip",exdir = "./Data")

## Change the Working Directory and read the data file
pwrConsumption <- read.table("./Data/household_power_consumption.txt", sep = ";", header = TRUE)

## Format the fields 
## Change the column to Data/ Time and Numeric format

x <- names(pwrConsumption) 
for (column in x){
  if (column == "Date"){
    pwrConsumption[,column] <- dmy(pwrConsumption[,column])
  }else if (column == "Time"){
    pwrConsumption[,column] <- hms(pwrConsumption[,column])
  }else{
    pwrConsumption[,column] <- as.numeric(pwrConsumption[, column])
  }
}

## Filter the data for required dates
pwr<- filter(pwrConsumption, Date == "2007-02-01" | Date == "2007-02-02")

## Add the Day and Date_long columns using dplyr

pwr <- pwr%>%
  mutate(Day = weekdays(Date, abbreviate = TRUE))
pwr <- pwr%>%
  mutate(Date_long = Date+Time)


## Setting plot Area
par(mfrow = c(1,1), mar = c(4,4,2,2))

## Plotting Histogram and review them

with(pwr, hist(Global_active_power, main = "Global Active Power", col = "red", xlab = "Global Active Power(kilowatts)"))


## Copy the plots to png file
dev.copy(png, "./plot1.png", width = 480, height = 480)
dev.off()