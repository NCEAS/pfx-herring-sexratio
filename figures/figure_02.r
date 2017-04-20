library(dplyr)
library(ggplot2)

d = readRDS("data/data_cleaned.rds")

Y = group_by(d, Year, gear) %>% 
  summarize(n = n())
Y$gear[which(Y$gear=="C")] = "Cast net"
Y$gear[which(Y$gear=="P")] = "Purse seine"

names(Y)[which(names(Y)=="gear")] = "Gear"

pdf("figures/Figure 02.pdf")
ggplot(Y, aes(Year, n)) + 
  geom_area(aes(fill= Gear), position = 'stack')  + 
  xlab("Year") + ylab("Samples") + scale_fill_manual(values=c("#043657", "#98c5ea")) + 
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
dev.off()