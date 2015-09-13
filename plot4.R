library(data.table)  #Needed for fread()
library(dplyr)       #Needed for mutate() and filter9)

#Fast read of data file
df <- fread("data/household_power_consumption.txt")

#We're interested only in a few days, so first filter on the two days 
# want and perform additional manipulations afterwards
df <- filter(df, Date == '1/2/2007' | Date == '2/2/2007')

#Create a new variable 'datetime' to add to the dataframe
# Note, discovered that package dplyr does not handle POSIClt well,
# hence the forced conversion to POSIXct
df <- mutate(df, datetime = as.POSIXct(strptime(paste(df$Date, df$Time), 
                                                '%d/%m/%Y %H:%M:%S')))


#During fread() all numeric columns defaulted to characters because of the
# handful of missing values stored as '?'
#Convert these back to numeric
df <- mutate(df, Global_active_power=as(Global_active_power, "numeric")) 
df <- mutate(df, Global_reactive_power=as(Global_reactive_power, "numeric"))
df <- mutate(df, Voltage=as(Voltage, "numeric"))
df <- mutate(df, Global_intensity=as(Global_intensity, "numeric"))
df <- mutate(df,Sub_metering_1=as(Sub_metering_1, "numeric"))
df <- mutate(df,Sub_metering_2=as(Sub_metering_2, "numeric"))
df <- mutate(df,Sub_metering_3=as(Sub_metering_3, "numeric"))

windows.options(width=480, height=480)

#Establish a png graphics device
png(file="plot4.png")

#Set up the next 4 plots as a 2 x 2 grid
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1))

#Plot 1
with(df, plot(datetime, 
              Global_active_power, 
              type="l", 
              xlab="", 
              ylab = "Global Active Power (kilowatts)"))

#Plot 2
with(df, plot(datetime, 
              Voltage, 
              type="l", 
              xlab = "datetime", 
              ylab = "Voltage"))

#Plot 3
plot(df$datetime, 
     df$Sub_metering_1, 
     type="l", 
     xlab="", 
     ylab = "Energy sub metering")

lines(df$datetime, 
      df$Sub_metering_2, 
      col='red')

lines(df$datetime, 
      df$Sub_metering_3, 
      col='blue')

legend(x="topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", 'Sub_metering_3'), 
       lwd = 1, 
       col=c("black","red","blue"))

#Plot 4
with(df, plot(datetime, 
              Global_reactive_power, 
              type="l",
              xlab = "datetime", 
              ylab = "Global_reactive_power"))

#Make sure to close the graphics device
dev.off()
