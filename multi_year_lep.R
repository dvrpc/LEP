years <- 2016:2020

# Set your working directory
setwd("C:\\Users\\jdobkin\\Documents\\outputs")

#census keys
Sys.getenv("CENSUS_API_KEY")

# Loop through each year
for (lep_year in years) {
  
  pumas <- get_acs(geography = "public use microdata area",
                   variables = c16001, 
                   survey = "acs5", 
                   year = lep_year,
                   state = lep_states,
                   output = "wide",
                   geometry = TRUE,
                   cache = TRUE)
  
  tracts <- get_acs(geography = "tract",
                    variables = c16001, 
                    survey = "acs5", 
                    year = lep_year,
                    state = lep_states,
                    output = "wide",
                    geometry = TRUE,
                    cache = TRUE)
  
  pumas2 <- get_acs(geography = "public use microdata area",
                    variables = b16001, 
                    survey = "acs5", 
                    year = lep_year,
                    state = lep_states,
                    output = "wide",
                    geometry = TRUE,
                    cache = TRUE)
  
  # Filter data
  tracts <- filter(tracts, as.numeric(substr(tracts$GEOID, start = 1, stop = 5)) %in% lep_counties)
  pumas <- filter(pumas, pumas$GEOID %in% puma_Codes)
  pumas2 <- filter(pumas2, pumas2$GEOID %in% puma_Codes)
  
  # Create a mapping of oldnames to newnames
  col_mapping <- setNames(newnames, oldnames)
  
  # Rename columns based on the mapping
  pumas <- pumas %>%
    rename_with(~ ifelse(. %in% oldnames, col_mapping[.], .), .cols = everything())
  
  tracts <- tracts %>%
    rename_with(~ ifelse(. %in% oldnames, col_mapping[.], .), .cols = everything())
  
  pumas2 <- pumas2 %>%
    rename_with(~ ifelse(. %in% oldnames, col_mapping[.], .), .cols = everything())
  
  # Export data
  write_csv(pumas, here(paste0("pumasLEP2_", lep_year, ".csv")))
  write_csv(tracts, here(paste0("tractsLEP2_", lep_year, ".csv")))
  write_csv(pumas2, here(paste0("longGrainLEP2_", lep_year, ".csv")))
  
  #st_write(pumas2, here(paste0("longGrainLEP_", lep_year, ".shp")))
  st_write(pumas, here(paste0("pumasLEP2_", lep_year, ".shp")))
  st_write(tracts, here(paste0("tracts2_", lep_year, ".shp")))
  
}