## Script make plot and save it as plot3.png

## This code work on Windows operation system
## Check download method and path wor another OS

## Make directory for data if it doesn't exist
if (!dir.exists("data")) {
  dir.create("data")
}
## Download file if it doesn't exist
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
## Read only used columns
DT <- fread("data\\household_power_consumption.txt",header = TRUE, sep = ";", 
            dec = ".", na.strings=c("?"), 
            select =  c("Date", "Time", "Sub_metering_1", "Sub_metering_2", 
                        "Sub_metering_3", "Global_active_power", "Voltage", 
                        "Global_reactive_power"))

## Filter data without Date transformation
## because we need only two days
graph_data <- DT[DT$Date == "1/2/2007" | DT$Date == "2/2/2007", ]

## Add datetime column
graph_data[, datetime := as.POSIXct(strptime(paste(Date, Time), 
                                             "%d/%m/%Y %H:%M:%S"))]

## Change time format because my system default language is russian
lc_time <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "C")

## Create png file with needed width and height
png(file = "plot4.png", width = 480, height = 480, bg = "transparent")

## Save graphical settings
.pardefault <- par(no.readonly = T)

## Set multiple row and columns
par(mfrow = c(2, 2))

## Draw plots
with(
  graph_data, plot(
    datetime, Global_active_power, type = "l", xlab = "", 
    ylab = "Global Active Power"
  )
)

## Draw plots
with(graph_data, plot(datetime, Voltage, type = "l", xlab = ""))

## Draw plots
with(
  graph_data, plot(
    datetime, Sub_metering_1, type = "n", xlab = "", 
    ylab = "Energy sub metering"
  )
)
with(graph_data, points(datetime, Sub_metering_1, type = "l"))
with(graph_data, points(datetime, Sub_metering_2, type = "l", col = "red"))
with(graph_data, points(datetime, Sub_metering_3, type = "l", col = "blue"))
legend(
  "topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
  lty = c(1,1),
  col = c("black", "blue","red"),
  bty = "n"
)

## Draw plots
with(
  graph_data, plot(
    datetime, Global_reactive_power, type = "l", xlab = "datetime"
  )
)

## Close file
dev.off()
## Restore graphical settings
par(.pardefault)