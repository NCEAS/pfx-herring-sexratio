library(dplyr)
library(ggplot2)

d = readRDS("data/data_cleaned.rds")

Y = group_by(d, Year, gear) %>% 
  summarize(m = mean(AGE,na.rm=T))
Y$gear[which(Y$gear=="C")] = "Cast net"
Y$gear[which(Y$gear=="P")] = "Purse seine"

names(Y)[which(names(Y)=="gear")] = "Gear"

pdf("figures/SI Figure 01_meanAge.pdf")
ggplot(Y, aes(Year, m, color = Gear, group=Gear)) + 
  geom_line(size=1) + xlab("Year") + ylab("Mean age") + scale_color_manual(values=c("#043657", "#98c5ea"))+
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
dev.off()

