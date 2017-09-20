# Data Manipulation with dplyr and reshape2 Presentation
# September 20, 2017
# Import and Prep CPS Data

# Packages
library(readr)
library(dplyr)

# Import Data
cps <- read_csv("~/Downloads/out-78973.csv")

# Fix Two Digit Years
cps$hryear4 <- ifelse(cps$hryear4 == 94, 1994, ifelse(cps$hryear4 == 95, 1995, ifelse(cps$hryear4 == 96, 1996, ifelse(cps$hryear4 == 97, 1997, cps$hryear4))))

# Make Date Variable
cps$date <- cps$hryear4*100 + cps$hrmonth

# Reduce to Adult Civilian Interviewed Population
df <- filter(cps, hrintsta == 1 & prpertyp == 2 & prtage >= 15)

# Merge in State Labels (optional)
fips2 <- read_csv("~/Desktop/fips2.csv")
df <- left_join(df, fips2); rm(fips2)

# Define Buckets
df$ageG <- ifelse(df$prtage < 25, 1, ifelse(df$prtage %in% 25:55, 2, ifelse(df$prtage %in% 56:65, 3, 4)))

df$lfs <- ifelse(df$pemlr %in% 1:2, 1, ifelse(df$pemlr %in% 3:4, 2, 3))

# More Labels (optional)
df$ageG <- factor(df$ageG, labels = c("young", "prime", "old", "golden"))

df$lfs <- factor(df$lfs, labels = c("E", "U", "N"))

df$pesex <- factor(df$pesex, labels = c("male", "female"))

# Per 1000 Adjusted Weight
df$wi <- df$pwsswgt/10000000


