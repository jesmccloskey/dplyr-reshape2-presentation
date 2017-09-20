# for presentation
# df from import.R

library(dplyr)
library(reshape2)
options(scipen=12)


# From Slide Examples ----------------------------------------------------

# Grab Data Used in Slide Examples
ex <- filter(df, date %in% 200712:201501 & lfs == "U")

# weighted version
ex %>% filter(date == 200801) %>% group_by(state) %>% summarize(nU = sum(wi)) %>% filter(nU == max(nU) | nU == min(nU))

# unweighted version
ex$indic <- 1
ex %>% filter(date == 200801) %>% group_by(state) %>% summarize(nU = sum(indic)) %>% filter(nU == max(nU) | nU == min(nU))

# see slides for the rest of the code run using the ex subset of data


# Extended Data Examples -------------------------------------------------

# Breakdown by All Breakdowns
df %>% group_by(date, ageG, lfs, pesex, state) %>% summarize(val = sum(wi)) -> out1
out1a <- dcast(out1, date ~ ageG + lfs + pesex + state)
out1b <- dcast(out1, date + lfs ~ ageG + pesex + state)
rm(out1, out1a, out1b)

# Status Counts by State Time Series Formatted
df %>% group_by(date, lfs, state) %>% summarize(val = sum(wi)) -> out2
out2 <- dcast(out2, date ~ lfs + state)
rm(out2)

# Status by Gender Over the Lifecycle
df %>% group_by(prtage, lfs, pesex) %>% summarize(val = sum(wi)) -> out3

library(ggplot2)

ggplot(out3) + geom_line(aes(x = prtage, y = val, color = lfs, group = lfs)) + facet_wrap(~pesex) + theme_bw()

# adjust for topcoding
p <- ggplot(out3[out3$prtage < 80, ]) + geom_line(aes(x = prtage, y = val, color = lfs, group = lfs), size = 0.5) + facet_wrap(~pesex) + theme_bw(base_size = 9) + labs(title = "Labor Force Status Over the Lifecycle", x = "Age", y = "Number with Status (Per 1000)", caption = "Source: JMcCloskey. Data: CPS via Cadre, KC FRB, 1994-2017, author calculation.")

ggsave("LC_lfs_gender.png", p, width = 6, height = 5)



