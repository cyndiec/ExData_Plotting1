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

#Create line graphs
png(filename="plot4.png",width=480,height=480,units="px",bg="transparent")
par(mfcol=c(2,2))

#First plot
plot(data$dateTime,data$Global_active_power,type="n",xlab='',ylab="Global Active Power")
lines(data$dateTime,data$Global_active_power,type="l")

#Second plot
plot(data$dateTime,data$Sub_metering_1,type="n",xlab='',ylab="Energy sub metering")
legend("topright",col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lwd=c(1,1,1),bty="n")
lines(data$dateTime,data$Sub_metering_1,type="l")
lines(data$dateTime,data$Sub_metering_2,type="l",col="red")
lines(data$dateTime,data$Sub_metering_3,type="l",col="blue")

#Third plot
plot(data$dateTime,data$Voltage,type="n",xlab="datetime",ylab="Voltage")
lines(data$dateTime,data$Voltage,type="l")

#Fourth plot
plot(data$dateTime,data$Global_reactive_power,type="n",xlab="datetime",ylab="Global_reactive_power")
lines(data$dateTime,data$Global_reactive_power,type="l")

#Close graphic device
dev.off()
