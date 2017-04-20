library(dplyr)
library(ggplot2)

d = readRDS("data/data_cleaned.rds")

Y1 = group_by(d, Year, gear) %>% 
  summarize(ntot = n()) 
Y = group_by(d, Year, gear, AGE) %>% 
  summarize(n = n()) %>%
  filter(AGE %in% c(3,4,5))
Y = left_join(Y, Y1)

Y$gear[which(Y$gear=="C")] = "Cast net"
Y$gear[which(Y$gear=="P")] = "Purse seine"

names(Y)[which(names(Y)=="gear")] = "Gear"

Y$Group = paste(Y$Gear,Y$AGE,sep=":")

pdf("figures/SI Figure 02_ageproportions.pdf")
ggplot(Y, aes(Year, n/ntot, color = Group, group=Group)) + 
  geom_line(size=1, linetype=1) + xlab("Year") + ylab("Proportion") +
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
dev.off()

