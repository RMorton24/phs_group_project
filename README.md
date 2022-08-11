# Public Health Scotland Group Project
> The following repository is for the CodeClan group project during the 
Professional Data Analysis Course. This has been completed in week 8 of the
course.

## Information
> The project is to create an RShiny app to analys

![](04_images/phs_logo.png) 

## Installations
Ensure the following packages are installed prior to running:

+ tidyverse
+ janitor
+ sf
+ tsibble
+ lubridate
+ plotly
+ shiny
+ htmlwidgets
+ shinydashboard
+ bslib
+ leaflet
+ shinyWidgets

__Run the following if required to install__
```
install.packages(tidyverse)
install.packages(janitor)
install.packages(sf)
install.packages(tsibble)
install.packages(lubridate)
install.packages(plotly)
install.packages(shiny)
install.packages(htmlwidgets)
install.packages(shinydashboard)
install.packages(bslib)
install.packages(leaflet)
install.packages(shinyWidgets)

```

## Folder Structure

The folder structure is the following:

| Folder | Description |
| :------|:-----------:|
| **01_data** | contains the raw data sets|
| **02_cleaned_data** | Contains the script for cleaning the raw data |
| **04_images** | Contains Images |
| **05_rshiny** | Contains the RShiny App |
| **06_dummy_code** | Contains some raw plots |
| **07_report** | Contains the raw data |
| **08_functions** | Contains the raw data |

## Data

All data has been obtained and is free for public use in the link with all data
coming under the following:

[Government License](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/)

The data which has been used within this Rshiny app are:
 
* [Hospital Activity page](https://www.opendata.nhs.scot/dataset/inpatient-and-daycase-activity/resource/c3b4be64-5fb4-4a2f-af41-b0012f0a276a)  

* [Hospital Activity by Speciality](https://www.opendata.nhs.scot/dataset/inpatient-and-daycase-activity/resource/c3b4be64-5fb4-4a2f-af41-b0012f0a276a)  

* [Hospital Activity and Patient Demographics](https://www.opendata.nhs.scot/dataset/inpatient-and-daycase-activity/resource/00c00ecc-b533-426e-a433-42d79bdea5d4)  

* [Hospital Activity and Deprivation](https://www.opendata.nhs.scot/dataset/inpatient-and-daycase-activity/resource/4fc640aa-bdd4-4fbe-805b-1da1c8ed6383)  

* [Hospitalisations due to Covid 19](https://www.opendata.nhs.scot/dataset/covid-19-wider-impacts-hospital-admissions)  

* [Quarterly Hospital Beds Information - Datasets - Scottish Health and Social Care Open Data - nhs.scot](https://www.opendata.nhs.scot/dataset/hospital-beds-information)  

* [COVID Impact - Excess Deaths](https://www.opendata.nhs.scot/dataset/covid-19-wider-impacts-deaths)

* [NHS Scotland Healthboard Region Shapes](https://spatialdata.gov.scot/geonetwork/srv/eng/catalog.search#/metadata/f12c3826-4b4b-40e6-bf4f-77b9ed01dc14)


## Cleaned Data

The cleaned data has been cleaned and wrangled
 
[Simple NHS Region Shapes](02_cleaned_data/nhs_region_simple)

[Link to cleaning scripts](02_cleaned_data/cleaning_scripts)

[Link to cleaned data](02_cleaned_data)

The cleaned data is:

* activity_deprivation.csv - Hospital activity by deprivations
* activity_patient_demographics.csv - Hospital activity by demographic
* admissions_by_speciality_clean.csv - Admissions by speciality
* bed_clean.csv - Quarterly Hospital beds data
* nhs_region_simple - Simplified NHS Scotland region geometry


## Data Analysis

The files within this folder were for generation of plot/analysis prior to
loading in to RShiny app.


## RShiny App

The RShiny app visualises the data in a dashboard.

### Tab 1 - 

### Tab 2 - 

### Tab 3 - 


## Report

The report details the working methodology of the group.


## Functions

The following functions are contained within the RShiny App (Leaflet Legend):

* `significance_round()` - Rounds values up or down to the nearest number of 
                            digits

| Arguments | Description |
| :---------|:-----------:|
| x | Numeric or Numeric Vector value which is to be rounded |
| round_up | Name of columns as character vector to check |
| digits | The number of digits |


[Link to function](08_functions/significance_round_function.R)

Code:
```
significance_round <- function(x, round_up = TRUE, digits = 1){
  
  if(x < 0){
    
    x <- abs(x)
    
    neg_multiplier <- -1
    
    if(round_up){
      x <- floor(x/10^ceiling(log10(x)- digits)) *10^ceiling(log10(x)- digits)
    }else{
      x <- ceiling(x/10^ceiling(log10(x)- digits)) *10^ceiling(log10(x)-digits)
    }
    
    x <- x * neg_multiplier
    
  }else{
    
    if(round_up){
      x <- ceiling(x/10^ceiling(log10(x)- digits)) *10^ceiling(log10(x)- digits)
    }else{
      x <- floor(x/10^ceiling(log10(x)- digits)) *10^ceiling(log10(x)-digits)
    }
    
  }
  return(x)
}

```

## Thanks

Special Thanks to the CodeClan Instructors and the DE15 Mascot Clive:

![](04_images/clive.jpg) 
