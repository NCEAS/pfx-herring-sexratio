##########HERRING GROWTH ANALYSIS###############

#Combining main dataset and subdataset

d = read.csv("data/PWS_Herring_Age_Sex_Length_Weight_1973-2014.csv")

# delete any of the rows that have values in comment field 
#d = d[-which(d$Comments!="")] 
d = d[which(d$Collection.Month%in%c(3, 4)),] 
d = d[which(d$Sex%in%c("M","F")),]

d$Image_Name = as.character(d$Image_Name) 
nchars = nchar(d$Image_Name) 
sexAge = substr(d$Image_Name, (nchars-1), nchars)

# Fix a few errors 
d$Image_Name[1252] = "9207TPZB_S7F23_M4" 
d$Image_Name[1313] = "9219SPNI_S5F27_F6" 
d$Image_Name[2962] = "0206TPSM_S4F7_M6" 
d$Image_Name[3755] = "0606TCLB_S1F9_M5" 
d$Image_Name[4050] = "0810TCSM_S25F7_M4"

slideFish = substr(d$Image_Name, 10, nchars-3)

d$fishID = as.numeric(unlist(lapply(strsplit(slideFish,"F") , getElement, 2)))

slide = unlist(lapply(strsplit(slideFish,"F") , getElement, 1)) 
d$slide = as.numeric(unlist(lapply(strsplit(slide, "S"), getElement, 2))) 
d$ID = paste(d$fishID,d$slide,d$FileName,sep=":")

fulldata = read.csv("data/df35b.276.1.csv") 
fulldata$ID = paste(fulldata$FISH..,fulldata$SLIDE,fulldata$FILENAME,sep=":")

fulldata$FILENAME = as.character(fulldata$FILENAME) 

# last 4 of code is FGLL, where F = fishery, G = gear, LL = location 
fulldata$fishery = substr(fulldata$FILENAME, 5, 5) 
fulldata$gear = substr(fulldata$FILENAME, 6, 6) 
fulldata$location = substr(fulldata$FILENAME, 7, 8)

matches = match(d$ID, fulldata$ID)

# Add gonad index 
d$GI = fulldata$GI.[matches] 
# Add length and weights 
d$length = fulldata$LENGTH[matches] 
d$weight = fulldata$WEIGHT[matches]

# add gear 
d$gear = fulldata$gear[matches] 
d$fishery = fulldata$fishery[matches] 
d$fishery[d$fishery%in%c("A", "T", "D")] = "Research"

saveRDS(d, "data/merged_data_1985_2013.rds")