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

## Section 2 - Create 4 chart visual and output to a .png file

plot.new()
png(filename = "plot4.png",
    width = 480, height = 480, units = "px", pointsize = 12,
    bg = "white", res = NA, family = "", restoreConsole = TRUE,
    type = c("windows", "cairo", "cairo-png"))

## Set up 2x2 visual, the populate the 4 graphs

par(mfrow=c(2,2), mar=c(4,4,2,1), oma = c(0,0,2,0))
with(pwrdata, {
    plot(DateTime, Global_active_power, 
        type ="l",
        xlab ="",
        ylab ="Global Active Power" )
    plot(DateTime, Voltage,
         type ="l",
         xlab ="datetime",
         ylab ="Voltage")
    plot(DateTime, 
         Sub_metering_1, 
         type ="l",
         xlab ="",
         ylab ="Energy sub metering" )
    lines(DateTime, 
          Sub_metering_2, 
          col = "red")
    lines(DateTime, 
          Sub_metering_3, 
          col = "blue")
    legend("topright",
           bty = "n",
           legend = names(pwrdata)[7:9], 
           col = c(1,2,4),
           lty = c(1,1,1))
    plot(DateTime, Global_reactive_power,
         type = "l",
         xlab = "datetime")
    }
)
dev.off()