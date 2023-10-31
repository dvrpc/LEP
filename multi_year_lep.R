#set years range, can be any number of years going back to 2016
years <- 2021

# Set your working directory
setwd("C:\\Users\\jdobkin\\Documents\\outputs")

#census keys
Sys.getenv("CENSUS_API_KEY")
census_api_key("219399afeaa3b3c28f7b5351b56bb92d7d0f576d", overwrite = TRUE)


# Loop through each year

#get_acs from census
for (lep_year in years) {
  pumas <-
    get_acs(
      geography = "public use microdata area",
      variables = c16001,
      survey = "acs5",
      year = lep_year,
      state = lep_states,
      output = "wide",
      geometry = TRUE,
      cache = TRUE
    )
  
  tracts <-
    get_acs(
      geography = "tract",
      variables = c16001,
      survey = "acs5",
      year = lep_year,
      state = lep_states,
      output = "wide",
      geometry = TRUE,
      cache = TRUE
    )
  
  pumas2 <-
    get_acs(
      geography = "public use microdata area",
      variables = b16001,
      survey = "acs5",
      year = lep_year,
      state = lep_states,
      output = "wide",
      geometry = TRUE,
      cache = TRUE
    )
  
  # Filter data for DVRPC region in variables file
  tracts <-
    filter(tracts, as.numeric(substr(
      tracts$GEOID, start = 1, stop = 5
    )) %in% lep_counties)
  pumas <- filter(pumas, pumas$GEOID %in% puma_Codes)
  pumas2 <- filter(pumas2, pumas2$GEOID %in% puma_Codes)
  
  # Create a mapping of oldnames to newnames
  col_mapping <- setNames(newnames, oldnames)
  col_mapping2 <- setNames(newnames_long, oldnames_long)
  
  # Rename columns based on the mapping
  pumas <- pumas %>%
    rename_with(~ ifelse(. %in% oldnames, col_mapping[.], .), .cols = everything())
  
  tracts <- tracts %>%
    rename_with(~ ifelse(. %in% oldnames, col_mapping[.], .), .cols = everything())
  pumas <- pumas %>%
    rename_with(~ ifelse(. %in% oldnames_long, col_mapping2[.], .), .cols = everything())
  
  tracts <- tracts %>%
    rename_with(~ ifelse(. %in% oldnames_long, col_mapping2[.], .), .cols = everything())
  
  #add tag for languages that are lep
  tracts$five_p <- tracts$TT_POP_E * 0.05
  
  tracts$change_tag <- case_when(
    (tracts$Span_Lim_E > tracts$five_p) ~ "Spanish",
    (tracts$FRE_Lim_E > tracts$five_p) ~ "French",
    (tracts$GER_Lim_E > tracts$five_p) ~ "German",
    (tracts$RUS_Lim_E > tracts$five_p) ~ "Russian",
    (tracts$IND_Lim_E > tracts$five_p) ~ "Indo-European",
    (tracts$KOR_Lim_E > tracts$five_p) ~ "Korean",
    (tracts$CHI_Lim_E > tracts$five_p) ~ "Chinese",
    (tracts$Viet_Lim_E > tracts$five_p) ~ "Vietnamese",
    (tracts$TAG_Lim_E > tracts$five_p) ~ "Tagalog",
    (tracts$PAC_Li_E > tracts$five_p) ~ "Asian and Pacific Island languages",
    (tracts$ARB_Lim_E > tracts$five_p) ~ "Arabic",
    (tracts$OTH_Lim_E > tracts$five_p) ~ "Other language",
    TRUE ~ "no LEP"
  )
  
  
  pumas <- pumas %>%
    rename_with(~ ifelse(. %in% oldnames_long, col_mapping2[.], .), .cols = everything())
  pumas$five_p <- pumas$TT_POP_E * 0.05
  
  pumas$change_tag <- case_when(
    (pumas$Span_Lim_E > pumas$five_p) ~ "Spanish",
    (pumas$FRE_Lim_E > pumas$five_p) ~ "French",
    (pumas$GER_Lim_E > pumas$five_p) ~ "German",
    (pumas$RUS_Lim_E > pumas$five_p) ~ "Russian",
    (pumas$IND_Lim_E > pumas$five_p) ~ "Indo-European",
    (pumas$KOR_Lim_E > pumas$five_p) ~ "Korean",
    (pumas$CHI_Lim_E > pumas$five_p) ~ "Chinese",
    (pumas$Viet_Lim_E > pumas$five_p) ~ "Vietnamese",
    (pumas$TAG_Lim_E > pumas$five_p) ~ "Tagalog",
    (pumas$PAC_Li_E > pumas$five_p) ~ "Asian and Pacific Island languages",
    (pumas$ARB_Lim_E > pumas$five_p) ~ "Arabic",
    (pumas$OTH_Lim_E > pumas$five_p) ~ "Other language",
    TRUE ~ "no LEP"
  )
  
  
  pumas2 <- pumas2 %>%
    rename_with(~ ifelse(. %in% oldnames_long, col_mapping2[.], .), .cols = everything())
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
    TRUE ~ "no LEP"
  )
  
  #eliminate unused variables
  pumas2 <- pumas2 %>%
    dplyr::select(-starts_with("C16001"))
  
  #find most common LEP
  
  #create just the LEP columns
  pumas_lim <- pumas[c(
    "Span_Lim_E",
    "FRE_Lim_E",
    "GER_Lim_E",
    "RUS_Lim_E",
    "IND_Lim_E",
    "KOR_Lim_E",
    "CHI_Lim_E",
    "Viet_Lim_E",
    "TAG_Lim_E",
    "PAC_Li_E",
    "ARB_Lim_E",
    "OTH_Lim_E"
  )]
  
  #change from sf to regular df
  pumas_lim <- pumas_lim %>% st_drop_geometry()
  #apply function to find largest LEP column
  largest_column <-
    colnames(pumas_lim)[apply(pumas_lim, 1, which.max)]
  #add that back into larger df
  pumas <- cbind(pumas, largest_column[drop = FALSE])
  
  #repeat process for tracts
  tracts_lim <- tracts[c(
    "Span_Lim_E",
    "FRE_Lim_E",
    "GER_Lim_E",
    "RUS_Lim_E",
    "IND_Lim_E",
    "KOR_Lim_E",
    "CHI_Lim_E",
    "Viet_Lim_E",
    "TAG_Lim_E",
    "PAC_Li_E",
    "ARB_Lim_E",
    "OTH_Lim_E"
  )]
  tracts_lim <- tracts_lim %>% st_drop_geometry()
  largest_column <-
    colnames(tracts_lim)[apply(tracts_lim, 1, which.max)]
  tracts <- cbind(tracts, largest_column[drop = FALSE])
  
  #repeat process for long form languages
  pumas2_lim <- pumas2[c(
    "Spa_Lim_E",
    "Fra_Lim_E",
    "Hat_Lim_E",
    "Ita_Lim_E",
    "Por_Lim_E",
    "Ger_Lim_E",
    "Germanic_Lim_E",
    "Gre_Lim_E",
    "Rus_Lim_E",
    "Pol_Lim_E",
    "Srp_hrv_Lim_E",
    "Ukr_sla_Lim_E",
    "Arm_Lim_E",
    "Per_Lim_E",
    "Guj_Lim_E",
    "Hin_Lim_E",
    "Urd_Lim_E",
    "Pan_Lim_E",
    "Ben_Lim_E",
    "Inc_Lim_E",
    "Ine_Lim_E",
    "Tel_Lim_E",
    "Tam_Lim_E",
    "Dra_Lim_E",
    "Chi_Lim_E",
    "Jpn_Lim_E",
    "Kor_Lim_E",
    "Hmong_Lim_E",
    "Viet_Lim_E",
    "Khmer_Lim_E",
    "Hmn_Lim_E",
    "Tai_Lim_E",
    "Oth_Asia_Lim_E",
    "Tgl_Lim_E",
    "Map_Lim_E",
    "Ara_Lim_E",
    "Heb_Lim_E",
    "Amh_Lim_E",
    "Yor_twi_ibo_oth_Lim_E",
    "Swa_oth_Lim_E",
    "Nav_Lim_E",
    "Oth_native_amer_Lim_E"
  )]
  pumas2_lim <- pumas2_lim %>% st_drop_geometry()
  largest_column <-
    colnames(pumas2_lim)[apply(pumas2_lim, 1, which.max)]
  pumas2 <- cbind(pumas2, largest_column[drop = FALSE])
  
  # calculate total LEP pop
  tracts$tt_pop_lep_e <- tracts$Span_Lim_E +
    tracts$FRE_Lim_E +
    tracts$GER_Lim_E +
    tracts$RUS_Lim_E +
    tracts$IND_Lim_E +
    tracts$KOR_Lim_E +
    tracts$CHI_Lim_E +
    tracts$Viet_Lim_E +
    tracts$TAG_Lim_E +
    tracts$PAC_Li_E +
    tracts$ARB_Lim_E +
    tracts$OTH_Lim_E
  
  pumas$tt_pop_lep_e <- pumas$Span_Lim_E +
    pumas$FRE_Lim_E +
    pumas$GER_Lim_E +
    pumas$RUS_Lim_E +
    pumas$IND_Lim_E +
    pumas$KOR_Lim_E +
    pumas$CHI_Lim_E +
    pumas$Viet_Lim_E +
    pumas$TAG_Lim_E +
    pumas$PAC_Li_E +
    pumas$ARB_Lim_E +
    pumas$OTH_Lim_E
  
  pumas2$tt_pop_lep_e <- pumas2$Spa_Lim_E +
    pumas2$Fra_Lim_E +
    pumas2$Hat_Lim_E +
    pumas2$Ita_Lim_E +
    pumas2$Por_Lim_E +
    pumas2$Ger_Lim_E +
    pumas2$Germanic_Lim_E +
    pumas2$Gre_Lim_E +
    pumas2$Rus_Lim_E +
    pumas2$Pol_Lim_E +
    pumas2$Srp_hrv_Lim_E +
    pumas2$Ukr_sla_Lim_E +
    pumas2$Arm_Lim_E +
    pumas2$Per_Lim_E +
    pumas2$Guj_Lim_E +
    pumas2$Hin_Lim_E +
    pumas2$Urd_Lim_E +
    pumas2$Pan_Lim_E +
    pumas2$Ben_Lim_E +
    pumas2$Inc_Lim_E +
    pumas2$Ine_Lim_E +
    pumas2$Tel_Lim_E +
    pumas2$Tam_Lim_E +
    pumas2$Dra_Lim_E +
    pumas2$Chi_Lim_E +
    pumas2$Jpn_Lim_E +
    pumas2$Kor_Lim_E +
    pumas2$Hmong_Lim_E +
    pumas2$Viet_Lim_E +
    pumas2$Khmer_Lim_E +
    pumas2$Hmn_Lim_E +
    pumas2$Tai_Lim_E +
    pumas2$Oth_Asia_Lim_E +
    pumas2$Tgl_Lim_E +
    pumas2$Map_Lim_E +
    pumas2$Ara_Lim_E +
    pumas2$Heb_Lim_E +
    pumas2$Amh_Lim_E +
    pumas2$Yor_twi_ibo_oth_Lim_E +
    pumas2$Swa_oth_Lim_E +
    pumas2$Nav_Lim_E +
    pumas2$Oth_native_amer_Lim_E
  
  
  # Export data
  #write_csv(pumas, here(paste0("pumasLEP_", lep_year, ".csv")))
  #write_csv(tracts, here(paste0("tractsLEP_", lep_year, ".csv")))
  #write_csv(pumas2, here(paste0("longGrainLEP_", lep_year, ".csv")))
  
  #st_write(pumas2, here(paste0("longGrainLEP_", lep_year, ".shp")))
  #st_write(pumas, here(paste0("pumasLEP_", lep_year, ".shp")))
  #st_write(tracts, here(paste0("tracts_", lep_year, ".shp")))
  
}