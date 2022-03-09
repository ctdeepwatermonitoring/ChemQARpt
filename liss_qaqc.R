# read in data
dt <- read.csv("data/Nutrient.csv", header = TRUE)
fd <- read.csv("data/Field_Data_Sheet.csv", header = TRUE)
st <- read.csv("data/stations.csv", header = TRUE)
df <- merge(dt,fd, by = c("Cruise","Station.Name"))

# add in yr column
df$Year <- as.integer(substr(df$Date,1,4))

# list of parameters in the data set
pr <- unique(data$Parameter)

dim(df[df$Year == 2021 & df$Parameter == 'NOX-LC',])


