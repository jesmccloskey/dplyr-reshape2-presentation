# Data Manipulation with dplyr and reshape2

This file contains the slides and code from my presentation. The original sildes are in the html file. There's also an included pdf version.

Code files:
1. `import.R` was used to import and format the CPS data accessed as described below. It uses the raw CPS data, and `fips2.csv` also included here
2. `analysis.R` uses the data from `import.R`, creates the small example dataset used in the slide examples, and has the larger dataset CPS example code, including the code to make the lifecycle graph

The reshape reference page is from [here](https://www.r-statistics.com/2012/01/aggregation-and-restructuring-data-from-r-in-action/). Note that when using reshape2, the `cast()` references on that page should be switched to `dcast()`. The other two reference pages are from the RStudio website.

## Getting Set Up to Follow Along 

1. Install R and optionally RStudio -- I use RStudio but it's not necessary for this presentation
2. Run `install.packages("dplyr")` and `install.packages("reshape2")` in R or RStudio (which ever you plan to use) to install those packages
3. Access example data as described below
4. Import example data (this should only take a minute once you have the directory path and file name figured out)


### CPS Data

The CPS data used can be accessed from the following source: [CPS](https://cps.kansascityfed.org/signin). You will need a Google account to sign in. Once signed in, under "Schema" select 1994 - Present (this is the default). Then select the following variables: HRMONTH, HRYEAR4, PWSSWGT, PRTAGE, PESEX, PEMLR, GESTFIPS, HRINTSTA, and PRPERTYP. The first three should already be selected by default. These will give standard breakdowns of employment, unemployment, and participation by age, gender, and state. You can also select other variables you're interested in seeing breakdowns for. 

When you're done selecting variables, select CSV as the Output Format (should be the default). Then enter a request identifier (a name that can be anything) and submit your request. You can wait for the request to finish and download the data or leave the site and return for it later. 

To import the data on a Mac, I used the following code. Note that your file name will be different and may be stored in a different directory. The argument inside `read_csv` needs to be updated to reflect your file name and directory path.

```r
# install.packages("readr") # uncomment if you don't already have this package installed
library(readr)
cps <- read_csv("~/Downloads/out-78973.csv")
```
Alternatively, you can use `read.csv()` without the readr package, but I suspect it will be slower.

*First Moves*

Following the above, you should have a dataframe named `cps` with 42,000,000 plus rows and 10 columns. These are the raw monthly individual level observations from the CPS from 1994 until present. Each row represents a particular individual in a particular month. Before using the data there are a few things you'd generally want to do. One is to fix the year variable for years 1994 - 1997. Those years have 2-digit values; starting in 1998, 4-digit values are used. Also you might want to reduce the sample to adult civilian interviewed members. The code below does that. 

```{r}
library(dplyr)

# Fix Two Digit Years
cps$hryear4 <- ifelse(cps$hryear4 == 94, 1994, ifelse(cps$hryear4 == 95, 1995, ifelse(cps$hryear4 == 96, 1996, ifelse(cps$hryear4 == 97, 1997, cps$hryear4))))

# Make Date Variable
cps$date <- cps$hryear4*100 + cps$hrmonth

# Reduce to Adult Civilian Interviewed Population
df <- filter(cps, hrintsta == 1 & prpertyp == 2 & prtage >= 15)

```

Note that the final line creates a new dataframe with a subset of the original observations. I often keep the full data or an easy to go back to version around for if (when) I mess something up along the way.

*Additional Labeling and Preparing*

A few other analysis specific preliminary steps are below. I'll talk more about this in the presentation. Note the first two lines reference an another file that will be available in this folder. You can download and use it, or skip those two lines.

```{r}
# Merge in State Labels (optional)
fips2 <- read_csv("~/Desktop/fips2.csv") ##### note directory path may need to be adjusted, or skip this and the next line
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

```


## Questions, Comments?

Email me at jesmccloskey@gmail.com.




