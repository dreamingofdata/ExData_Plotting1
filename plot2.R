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

#Establish a png graphics device
png(file="plot2.png")

#Generate the linear plot
with(df, plot(datetime, 
              Global_active_power, 
              type="l", 
              xlab="", 
              ylab = "Global Active Power (kilowatts)"))

#Make sure to close the graphics device
dev.off()
