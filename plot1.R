## Script make plot and save it as plot1.png

## This code work on Windows operation system
## Check download method and path for another OS

## Make directory for data if it doesn't exist
if (!dir.exists("data")) {
  dir.create("data")
}
## Download data file if it doesn't exist
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
## Load only necessary column
DT <- fread( "data\\household_power_consumption.txt",header = TRUE, 
               sep = ";", dec = ".", na.strings=c("?"), 
               select =  c("Date", "Global_active_power"))

## Get data for plot
## Filter data without Date transformation
## because we need only two days
graph_data <- DT[DT$Date == "1/2/2007" | 
                     DT$Date == "2/2/2007", ]$Global_active_power


## Create png file with needed width and height
png(file = "plot1.png", width=480, height=480, bg = "transparent")

## Draw plot
hist(graph_data, col = "red", xlab = "Global Active Power (kilowatts)", 
     main = "Global Active Power")

dev.off()

