## Script make plot and save it as plot2.png

## This code work on Windows operation system
## Check download method and path for another OS

## make directory for data if it doesn't exist
if (!dir.exists("data")) {
  dir.create("data")
}
## download file if it doesn't exist
if (!file.exists("data\\household_power_consumption.txt")) {
  if (!file.exists("data\\household_power_consumption.zip")) {
    fileUrl <-
      "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, "data\\household_power_consumption.zip")
  }
  unzip("data\\household_power_consumption.zip", exdir = "data")
}

## data.table package used
require(data.table)

## load only necessary column
DT <- fread("data\\household_power_consumption.txt",header = TRUE, sep = ";", 
            dec = ".", na.strings=c("?"), 
            select =  c("Date", "Time", "Global_active_power"))

## Get data for plot
## Filter data without Date transformation
## because we need only two days
graph_data <- DT[DT$Date == "1/2/2007" | DT$Date == "2/2/2007", ]


## Add datetime column from Date and Time
graph_data[, datetime := as.POSIXct(strptime(paste(Date, Time), 
                                             "%d/%m/%Y %H:%M:%S"))]

## Change time format because my system default language is russian
lc_time <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "C")

## create png file with needed width and height
png(file = "plot2.png", width=480, height=480)

## Draw line
with(graph_data, plot(datetime, Global_active_power, type = "l", 
                      xlab = "", ylab = "Global Active Power (kilowatts)"))
## Close file
dev.off()

## Restore time format
Sys.setlocale("LC_TIME", lc_time)
