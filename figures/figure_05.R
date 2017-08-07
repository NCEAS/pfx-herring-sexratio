library(dplyr)
library(ggplot2)

d = readRDS("data/data_cleaned.rds")

Y = filter(d, gear == "P") %>% group_by(Year) %>%
 summarize(n_males = length(which(SEX==1)),
 n = n(), p_male = n_males/n) %>% 
 select(-n_males, -n)

pdf("figures/Figure 05.pdf")
ggplot(Y, aes(Year, p_male)) + geom_point(color = "blue", alpha=0.7, size=3) + 
  xlab("Year") + ylab("Percent male") + geom_smooth(method='lm', colour="grey30") + 
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) + geom_hline(aes(yintercept=0.5), linetype=2)
dev.off()