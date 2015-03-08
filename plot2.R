#Download and unzip file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","data.zip","curl")
unzip("data.zip")
install.packages("lubridate")
library(lubridate)

#Define parameters
filename <- "household_power_consumption.txt"
con <- file(filename)
regex <- "^[12]/2/2007"

# Get the lines that contain the correct dates.
# Assumes the file orders the dates in ascending order
# and contains at least one instance of desired date.
lineNumbers <- grep("^[12]/2/2007",readLines(con))
skipInt <- lineNumbers[1]
rows <- length(lineNumbers)

#Close connection to file
close(con)

#Read data into the console
data <- read.csv(filename,sep=";",na.strings = "?",
                 skip=skipInt,nrows=rows,
                 col.names=c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3"))

#Reformat date and time
data$Date <- dmy(data$Date)
data$Time <- hms(data$Time)

#Create dateTime 
data$dateTime <- data$Date + data$Time

#Create line graph
plot(data$dateTime,data$Global_active_power,type="n",xlab='',ylab="Global Active Power (kilowatters)")
lines(data$dateTime,data$Global_active_power,type="l")

#Copy line graph to png file
dev.copy(png,filename="plot2.png",width=480,height=480,units="px")

#Close graphics devices
dev.off()
dev.off()
