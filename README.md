# Data Manipulation with dplyr and reshape2

Eventually, I will post the slides, example code, and maybe some other resources here.

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


