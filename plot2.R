## This script assumes the datafile in the R working directory

## Section 1 - Load powerdata. This section is the same for all
## four of the plot scripts. The code for the actual plots begins
## on line 30

library(data.table)
library(plyr); library(dplyr)

## Read power consumption file column headings
## Read rows for the approximate date range (less memory use)

fname <- "household_power_consumption.txt"
headings <- fread(fname,nrows=0)
pwr <- fread(fname,nrows = 10000, na.strings = "?", skip = 60000)
names(pwr) <- names(headings)

## Isolate rows for the exact dates and store in a new dataframe
## Add a DateTime column with the correct format

pwrdata <- pwr[pwr$Date == "1/2/2007" | pwr$Date == "2/2/2007",]
DateTime <- strptime(paste(pwrdata$Date,pwrdata$Time),
                        format = "%d/%m/%Y %T")
pwrdata <- cbind(pwrdata,DateTime)

## clean-up extra data.frames 

rm(list = c("pwr","headings","DateTime"))

## Section 2 - Create line plot and output to a .png file

plot.new()
png(filename = "plot2.png",
    width = 480, height = 480, units = "px", pointsize = 12,
    bg = "white", res = NA, family = "", restoreConsole = TRUE,
    type = c("windows", "cairo", "cairo-png"))

## Create line plot

with(pwrdata, 
     plot(DateTime, Global_active_power, 
          type ="l",
          xlab ="",
          ylab ="Global Active Power (kilowatts)" )
)
dev.off()
