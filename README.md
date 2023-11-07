# LEP
# Indicators of Potential Disadvantage

This project automates parts of DVRPC's Limited english profenency (LEP) analysis, including data download, processing, and export. 
The data is based on the American Community Survey 5 year Estimates for Tract and Public Use Microdata Area (PUMAs) geographies.

Please note that this product makes use of both the `B16001` and `C16001` language tables. The `C16001` offers more detailed language groups and should not be used in comparison with `B16001` observations of the same name.

## Getting the Code and Software

1. Clone the repository. 
2. Download and install R from https://www.r-project.org/
3. Download and install R Studio from https://www.rstudio.com/products/rstudio/#Desktop
4. Open the code files directly in R Studio. If needed, push commits through GitHub desktop.
5. Create the .Renviron files 
These files include screts, such as passwords and API keys in this format:
`password1=password_without_quotation_marks
password2=0000
path1=C:/path/to/folder`

The Files can be created in R studio through Files -> New Files -> Text File with type as R.environ when saving.

## Installing Package Dependencies 

The R script has the following dependencies: 

`plyr; here; sf; summarytools; survey; srvyr; sjmisc; tidycensus; tidyverse; tigris; dplyr; descr; sp; rgdal; raster`

If you have not previously installed the dependencies, you will need to do so. If you try to run the script without installing the packages, you will get an error message like 
`Error in library (name_of_package) : there is no package called 'name_of_package'`.

Install each package from R Studio's console (typically at the bottom of the screen in R Studio) with the command  `install.packages('name_of_package')` (include the quotation marks). 

## Updating the Script for a New 5-Year Dataset

If you are running the code against a newly released 5-year ACS dataset, do the following:

1. Make a copy of the latest variables.R file  and rename it for the year you are working on. (This is to ensure that any schema changes for a particular 5-year dataset are kept with the code for that set.)
2. Adjust the value for the `lep_year` variable (to be the end year of the dataset).
3. Verify the field names (listed in the variables.R file).
4. Ensure that the year variables match the years you are querying multiple years can be queried back to the 2011 - 2016 ACS-5 year study. This can be done using the following format.
`years <- 2016:2021`

## Running the Code

1. Open RStudio. 
2. Open the R file (File -> Open File)
3. Start with the variables.R file running it in its entirety then run the multi-year-lep.R file
4. Run the code by clicking the Source button or Ctrl+A followed by Ctrl+Enter.
5. Once the code is run it will place the outputs in your current working directory to change this reset your current working directory in your session settings.

## Outputs
This code generates 6 output files for each survey. This include .csv and .shp versions of the same outputs.
The `tractsLEP` files contain the abbreviated language groups at the census tract level from the B16001 ACS 5 year table.
The `pumasLEP` files contain the abbreviated language groups at the Public Use Microdata Areas level from the B16001 ACS 5 year table.
The `longGrainLEP` files contain the unabbreviated language groups only available at the Public Use Microdata Areas level from the C16001 ACS 5 year table.
Please note that the unabbreviated language groups have cannot be directly compared to the abbreviated language groups.