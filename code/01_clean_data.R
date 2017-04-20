d = read.csv("data/df35b.276.1.csv")

# delete any of the rows that have values in comment field 
d = d[-which(d$Comments!="")]
# restrict months to march-april
d = d[which(d$Month%in%c(3, 4)),]
# don't include unsexed animals
d = d[which(d$SEX%in%c(1,2)),]
# re-label females = 0, males = 1
d$SEX[d$SEX==2] = 0 # females

# Split out the gear, location, and fishery from the filename code.
d$FILENAME = as.character(d$FILENAME)
# last 4 of code is FGLL, where F = fishery, G = gear, LL = location
d$fishery = substr(d$FILENAME, 5, 5)
d$gear = substr(d$FILENAME, 6, 6)
d$location = substr(d$FILENAME, 7, 8)

table(d$location)

# sites according to 2 different papers
d$oiled = NA
d$oiled[which(d$location%in%c("SH", "PP", "HB"))] = "Y"
d$oiled[which(d$location%in%c("CP", "LB", "MB", "RB", "ZB"))] = "N"

# combine research samples
# Gillnets used by commercial have stronger selection (likely) for bigger
# fish, research samples use variable mesh gillnet.
d$fishery[d$fishery%in%c("A", "T", "D")] = "Research"
d = d[d$fishery%in%c("Research"),] # only research samples

# look at two dominant gears
d = d[d$gear%in%c("C", "P"),] # cast, purse seine

# only look at ages 1-11
d = d[d$AGE %in% seq(1,11), ]

# temporally, we'll restrict the analysis to data from 1983 on. There's samples in 1976/1977, but very small, and the gap may affect the longer term trend.
d = d[d$Year > 1982,]

saveRDS(d, "data_cleaned.rds")