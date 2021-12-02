#install via downloading package

install.packages("cancensus")

library(cancensus)
library(tidyverse)
library(dplyr)

options(cancensus.api_key = "CensusMapper_330652d5ae9c2ccaafc7883a06fb3967")
options(cancensus.cache_path = "./CancensusCache")

set_api_key("CensusMapper_330652d5ae9c2ccaafc7883a06fb3967", install = TRUE)


cancensus <- list_census_datasets()

kelownaCMA16 <- list_census_regions('CA16') %>%
  filter(level == "CMA", name %in% "Kelowna")

#"kelownaCT16" below is census tract data for Kelowna according to 2016 census data.

kelownaCT16 <- get_census(dataset='CA16', regions=list(CMA='59915'),
          vectors=c("v_CA16_408","v_CA16_409","v_CA16_410"),
          level = 'CT', use_cache = FALSE)

#The dataset above includes census tracts in WK and the first nation.
#I will drop those. Hence, "CoKCT16" is the dataset we will be using
#for the following analysis.

CoKCT16 <- kelownaCT16 %>%
          filter(!GeoUID %in% c("9150100.00", "9150101.00","9150102.01",
                            "9150102.04", "9150102.05",
                            "9150102.06", "9150103.00",
                            "9150104.01", "9150104.02",
                            "9150105.01", "9150105.02", "9150105.03"))


explore_census_vectors(dataset= "CA16")

#How does dissemination areas look like?

kelownaDA16 <- get_census(dataset='CA16', regions=list(CMA='59915'),
                          vectors=c("v_CA16_408","v_CA16_409","v_CA16_410"),
                          level = 'DA', use_cache = FALSE)


#Now I will look at age variables for CoK. I want to get data for
# age groups, 0~4 & 65+.

find_census_vectors("0 to 4 years", dataset = "CA16", type = "total", query_type = "exact")
