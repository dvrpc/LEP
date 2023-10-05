years <- 2016:2020

# Set your working directory
setwd("C:\\Users\\jdobkin\\Documents\\outputs")

#census keys
Sys.getenv("CENSUS_API_KEY")

# Loop through each year
for (lep_year in years) {

  pumas <- get_acs(geography = "public use microdata area", variables = c16001, survey = "acs5", year = lep_year, state = lep_states, output = "wide",
    geometry = TRUE, cache = TRUE)

  tracts <- get_acs(geography = "tract", variables = c16001, survey = "acs5", year = lep_year, state = lep_states, output = "wide", geometry = TRUE,
    cache = TRUE)

  pumas2 <- get_acs(geography = "public use microdata area", variables = b16001, survey = "acs5", year = lep_year, state = lep_states, output = "wide",
    geometry = TRUE, cache = TRUE)

  # Filter data
  tracts <- filter(tracts, as.numeric(substr(tracts$GEOID, start = 1, stop = 5)) %in% lep_counties)
  pumas <- filter(pumas, pumas$GEOID %in% puma_Codes)
  pumas2 <- filter(pumas2, pumas2$GEOID %in% puma_Codes)

  # Create a mapping of oldnames to newnames
  col_mapping <- setNames(newnames, oldnames)
  col_mapping2 <- setNames(newnames_long, oldnames_long)

  # Rename columns based on the mapping
  pumas <- pumas %>%
    rename_with(~ifelse(. %in% oldnames, col_mapping[.], .), .cols = everything())

  tracts <- tracts %>%
    rename_with(~ifelse(. %in% oldnames, col_mapping[.], .), .cols = everything())

  pumas2 <- pumas2 %>%
    rename_with(~ifelse(. %in% oldnames_long, col_mapping2[.], .), .cols = everything())
  pumas2$five_p <- pumas2$TT_POP_E * 0.05
    
  pumas2$change_tag <- case_when(
    (pumas2$Spa_Lim_E > pumas2$five_p) ~ "Spanish",
    (pumas2$Fra_Lim_E > pumas2$five_p) ~ "French",
    (pumas2$Hat_Lim_E > pumas2$five_p) ~ "Haitian",
    (pumas2$Ita_Lim_E > pumas2$five_p) ~ "Italian",
    (pumas2$Por_Lim_E > pumas2$five_p) ~ "Portuguese",
    (pumas2$Ger_Lim_E > pumas2$five_p) ~ "German",
    (pumas2$Germanic_Lim_E > pumas2$five_p) ~ "Other West Germanic",
    (pumas2$Gre_Lim_E > pumas2$five_p) ~ "Greek",
    (pumas2$Rus_Lim_E > pumas2$five_p) ~ "Russian",
    (pumas2$Pol_Lim_E > pumas2$five_p) ~ "Polish",
    (pumas2$Srp_hrv_Lim_E > pumas2$five_p) ~ "Serbo-Croatian",
    (pumas2$Ukr_sla_Lim_E > pumas2$five_p) ~ "Ukrainian or Slavic",
    (pumas2$Arm_Lim_E > pumas2$five_p) ~ "Armenian",
    (pumas2$Per_Lim_E > pumas2$five_p) ~ "Persian",
    (pumas2$Guj_Lim_E > pumas2$five_p) ~ "Gujarati",
    (pumas2$Hin_Lim_E > pumas2$five_p) ~ "Hindi",
    (pumas2$Urd_Lim_E > pumas2$five_p) ~ "Urdu",
    (pumas2$Pan_Lim_E > pumas2$five_p) ~ "Punjabi",
    (pumas2$Ben_Lim_E > pumas2$five_p) ~ "Bengali",
    (pumas2$Inc_Lim_E > pumas2$five_p) ~ "Indic",
    (pumas2$Ine_Lim_E > pumas2$five_p) ~ "Other Indo-European",
    (pumas2$Tel_Lim_E > pumas2$five_p) ~ "Telugu",
    (pumas2$Tam_Lim_E > pumas2$five_p) ~ "Tamil",
    (pumas2$Dra_Lim_E > pumas2$five_p) ~ "Dravidian",
    (pumas2$Chi_Lim_E > pumas2$five_p) ~ "Chinese",
    (pumas2$Jpn_Lim_E > pumas2$five_p) ~ "Japanese",
    (pumas2$Kor_Lim_E > pumas2$five_p) ~ "Korean",
    (pumas2$Hmong_Lim_E > pumas2$five_p) ~ "Hmong",
    (pumas2$Viet_Lim_E > pumas2$five_p) ~ "Vietnamese",
    (pumas2$Khmer_Lim_E > pumas2$five_p) ~ "Khmer",
    (pumas2$Hmn_Lim_E > pumas2$five_p) ~ "Hmong (Other)",
    (pumas2$Tai_Lim_E > pumas2$five_p) ~ "Tai",
    (pumas2$Oth_Asia_Lim_E > pumas2$five_p) ~ "Other Asian",
    (pumas2$Tgl_Lim_E > pumas2$five_p) ~ "Tagalog",
    (pumas2$Map_Lim_E > pumas2$five_p) ~ "Malayalam, Kannada, or Tamil",
    (pumas2$Ara_Lim_E > pumas2$five_p) ~ "Arabic",
    (pumas2$Heb_Lim_E > pumas2$five_p) ~ "Hebrew",
    (pumas2$Amh_Lim_E > pumas2$five_p) ~ "Amharic",
    (pumas2$Yor_twi_ibo_oth_Lim_E > pumas2$five_p) ~ "Yoruba, Twi, Igbo, or Other African",
    (pumas2$Swa_oth_Lim_E > pumas2$five_p) ~ "Swahili or Other African",
    (pumas2$Nav_Lim_E > pumas2$five_p) ~ "Navajo",
    (pumas2$Oth_native_amer_Lim_E > pumas2$five_p) ~ "Other Native American",
    TRUE ~ "no change"
  )
  
  pumas2 <- pumas2 %>%
    dplyr::select(-starts_with("C16001"))
  
  # Export data
  write_csv(pumas, here(paste0("pumasLEPtag_", lep_year, ".csv")))
  write_csv(tracts, here(paste0("tractsLEPtag_", lep_year, ".csv")))
  write_csv(pumas2, here(paste0("longGrainLEPtag2_", lep_year, ".csv")))

  st_write(pumas2, here(paste0("longGrainLEPtag2_", lep_year, ".shp")))
  st_write(pumas, here(paste0("pumasLEPtag_", lep_year, ".shp")))
  st_write(tracts, here(paste0("tractstag_", lep_year, ".shp")))

}