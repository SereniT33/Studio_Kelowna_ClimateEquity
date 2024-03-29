#install via downloading package

install.packages("cancensus")
install.packages("sf")
install.packages("geojsonsf")

library(cancensus)
library(sf)
library(geojsonsf)
library(tidyverse)
library(dplyr)
library(sf)
library(geojsonsf)

setwd("E:/ArcGIS")

options(cancensus.api_key = "CensusMapper_330652d5ae9c2ccaafc7883a06fb3967")
options(cancensus.cache_path = "./CancensusCache")

set_api_key("CensusMapper_330652d5ae9c2ccaafc7883a06fb3967", install=TRUE)


cancensus <- list_census_datasets()

kelownaCMA16 <- list_census_regions('CA16') %>%
  filter(level == "CMA", name %in% "Kelowna")


#"kelownaCT16" below is census tract data for Kelowna according to 2016 census data.

kelownaCT16 <- get_census(dataset='CA16', regions=list(CMA='59915'),
          vectors=c("v_CA16_408","v_CA16_409","v_CA16_410", "v_CA16_7", "v_CA16_244"),
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


#Now I will find vector #'s for each variables.


#First, we will find the vector #'s for age.
#age "0 to 4 years" is "v_CA16_7".
#age "65 years and over" is v_CA16_244.

find_census_vectors("0 to 4 years", dataset = "CA16", type = "total", query_type = "exact")
find_census_vectors("65 years", dataset = "CA16", type = "total", query_type = "exact")
find_census_vectors("0 to 4 years", dataset = "CA16", type = "total", query_type = "exact")


#Second is the visible minority population. (vector# v_CA16_3957)
find_census_vectors("visible minority", dataset = "CA16", type = "total", query_type = "exact")

#Third is the knowledge of language - "neither English nor French".
# (vector# V_CA16_524) While I chose 524, vector ~539 also shows up.
find_census_vectors("neither English nor", dataset = "CA16", type = "total", query_type = "exact")

#Fourth, "Median after-tax income of one-person households in 2015"
#and "Median after-tax income of two-or-more-person households in 2015" are
# (v_CA16_2401) & (v_CA16_2404)
find_census_vectors("Median after-tax income of one-person households in 2015", dataset = "CA16", type = "total", query_type = "exact")
find_census_vectors("Median after-tax income of two-or-more-person households in 2015", dataset = "CA16", type = "total", query_type = "exact")


#Fifth, education attainment, "no certificate, diploma or degree"
# vector# v_CA16_5054. (also note, 5099)
find_census_vectors("no certificate, diploma", dataset = "CA16", type = "total", query_type = "exact")

#Sixth, primary/tourism industry. These industries include
#"Agriculture, forestry, fishing and hunting" (v_CA16_5702),
#"Mining, quarrying, and oil and gas extraction" (v_CA16_5705),
#for the primary industries, and
#"Transportation and warehousing" (v_CA16_5723),
#"Arts, entertainment and recreation" (v_CA16_5750),
#"Accommodation and food services" (v_CA16_5753)
#for tourism.
find_census_vectors("Agriculture, forestry", dataset = "CA16", type = "total", query_type = "exact")
find_census_vectors("Mining, quarrying, and oil", dataset = "CA16", type = "total", query_type = "exact")
find_census_vectors("Transportation and warehousing", dataset = "CA16", type = "total", query_type = "exact")
find_census_vectors("Arts, entertainment", dataset = "CA16", type = "total", query_type = "exact")
find_census_vectors("Accommodation and food", dataset = "CA16", type = "total", query_type = "exact")

#Seventh, home ownership data has
#"Owner" (v_CA16_4837) & "Renter" (v_CA16_4838)
find_census_vectors("Owner", dataset = "CA16", type = "total", query_type = "exact")
find_census_vectors("Renter", dataset = "CA16", type = "total", query_type = "exact")

#Eighth, structure types of dwelling include
#"Single-detached house" (v_CA16_40),
#"Apartment in a building that has five or more storeys" (v_CA16_410),
#"Movable dwelling" (v_CA16_417).

find_census_vectors("Single-detached house", dataset = "CA16", type = "total", query_type = "exact")
find_census_vectors("Apartment in a building that has five or more storeys", dataset = "CA16", type = "total", query_type = "exact")
find_census_vectors("Movable dwelling", dataset = "CA16", type = "total", query_type = "exact")

#Ninth, living alone is determined by
# household size of "1 person". (v_CA16_419)

find_census_vectors("1 person", dataset = "CA16", type = "total", query_type = "exact")




# Accordingly, I will make 9 data sets for each 9 groups of variables.

#First, age

CT16Age <- get_census(dataset='CA16', regions=list(CMA='59915'),
                          vectors=c("v_CA16_7","v_CA16_244"),
                          level = 'CT', geo_format ="sf", use_cache = FALSE) %>%
                filter(!GeoUID %in% c("9150100.00", "9150101.00","9150102.01",
                        "9150102.04", "9150102.05",
                        "9150102.06", "9150103.00",
                        "9150104.01", "9150104.02",
                        "9150105.01", "9150105.02", "9150105.03"))
st_write(CT16Age, "Age.shp")



plot(CT16Age[""])

st_write(CT16Age, "Age_shp", driver="ESRI Shapefile")

#Second, visible minority pop.

CT16Race <- get_census(dataset='CA16', regions=list(CMA='59915'),
                       vectors= "v_CA16_3957",
                       level = 'CT', geo_format ="sf", use_cache = FALSE) %>%
  filter(!GeoUID %in% c("9150100.00", "9150101.00","9150102.01",
                        "9150102.04", "9150102.05",
                        "9150102.06", "9150103.00",
                        "9150104.01", "9150104.02",
                        "9150105.01", "9150105.02", "9150105.03"))
st_write(CT16Race, "Race.shp")

st_write(CT16Race, "VisualMinority_shp", driver="ESRI Shapefile")

#Third, language proficiency

CT16Language <- get_census(dataset='CA16', regions=list(CMA='59915'),
                           vectors= "v_CA16_524",
                           level = 'CT', geo_format ="sf", use_cache = FALSE) %>%
  filter(!GeoUID %in% c("9150100.00", "9150101.00","9150102.01",
                        "9150102.04", "9150102.05",
                        "9150102.06", "9150103.00",
                        "9150104.01", "9150104.02",
                        "9150105.01", "9150105.02", "9150105.03"))
<<<<<<< HEAD
st_write(CT16Language, "Language.shp")

=======
st_write(CT16Age, "Language_shp", driver="ESRI Shapefile")
>>>>>>> bd8af6db5733e76c757a72a0e6db25b027874ef8

#Fourth, income
CT16Income <- get_census(dataset='CA16', regions=list(CMA='59915'),
                         vectors=c("v_CA16_2401","v_CA16_2404"),
                         level = 'CT', geo_format ="sf", use_cache = FALSE) %>%
  filter(!GeoUID %in% c("9150100.00", "9150101.00","9150102.01",
                        "9150102.04", "9150102.05",
                        "9150102.06", "9150103.00",
                        "9150104.01", "9150104.02",
                        "9150105.01", "9150105.02", "9150105.03"))

<<<<<<< HEAD
st_write(CT16Income, "Income.shp")
=======
st_write(CT16Age, "Income_shp", driver="ESRI Shapefile")
>>>>>>> bd8af6db5733e76c757a72a0e6db25b027874ef8

#Fifth, education attainment

CT16Education <- get_census(dataset='CA16', regions=list(CMA='59915'),
                            vectors= "v_CA16_5054",
                            level = 'CT', geo_format ="sf", use_cache = FALSE) %>%
  filter(!GeoUID %in% c("9150100.00", "9150101.00","9150102.01",
                        "9150102.04", "9150102.05",
                        "9150102.06", "9150103.00",
                        "9150104.01", "9150104.02",
                        "9150105.01", "9150105.02", "9150105.03"))
st_write(CT16Education, "Education.shp")


st_write(CT16Age, "Education_shp", driver="ESRI Shapefile")

#Sixth, primary & tourism industry

CT16PrimaryTourism <- get_census(dataset='CA16', regions=list(CMA='59915'),
                                 vectors=c("v_CA16_5702","v_CA16_5705",
                                           "v_CA16_5723", "v_CA16_5750",
                                           "v_CA16_5753"),
                                 level = 'CT', use_cache = FALSE) %>%
  filter(!GeoUID %in% c("9150100.00", "9150101.00","9150102.01",
                        "9150102.04", "9150102.05",
                        "9150102.06", "9150103.00",
                        "9150104.01", "9150104.02",
                        "9150105.01", "9150105.02", "9150105.03"))

st_write(CT16Age, "PrimaryTourism_shp", driver="ESRI Shapefile")


#Seventh, home ownership

CT16HomeOwnership <- get_census(dataset='CA16', regions=list(CMA='59915'),
                                vectors=c("v_CA16_4837","v_CA16_4838"),
                                level = 'CT', geo_format ="sf", use_cache = FALSE) %>%
  filter(!GeoUID %in% c("9150100.00", "9150101.00","9150102.01",
                        "9150102.04", "9150102.05",
                        "9150102.06", "9150103.00",
                        "9150104.01", "9150104.02",
                        "9150105.01", "9150105.02", "9150105.03"))
st_write(CT16HomeOwnership, "Homeownership.shp")



st_write(CT16Age, "Homeownership_shp", driver="ESRI Shapefile")

#Eighth, dwelling structure

CT16DwellingStructure <- get_census(dataset='CA16', regions=list(CMA='59915'),
                                vectors=c("v_CA16_40","v_CA16_410", "v_CA16_417"),
                                level = 'CT', geo_format ="sf", use_cache = FALSE) %>%
  filter(!GeoUID %in% c("9150100.00", "9150101.00","9150102.01",
                        "9150102.04", "9150102.05",
                        "9150102.06", "9150103.00",
                        "9150104.01", "9150104.02",
                        "9150105.01", "9150105.02", "9150105.03"))
st_write(CT16DwellingStructure, "Dwelling.shp")


st_write(CT16Age, "DwellingStructure_shp", driver="ESRI Shapefile")

#Ninth, living alone
CT16LiveAlone <- get_census(dataset='CA16', regions=list(CMA='59915'),
                            vectors= "v_CA16_419",
                            level = 'CT', geo_format ="sf", use_cache = FALSE) %>%
  filter(!GeoUID %in% c("9150100.00", "9150101.00","9150102.01",
                        "9150102.04", "9150102.05",
                        "9150102.06", "9150103.00",
                        "9150104.01", "9150104.02",
                        "9150105.01", "9150105.02", "9150105.03"))
<<<<<<< HEAD
st_write(CT16LiveAlone, "LiveAlone.shp")
=======


st_write(CT16Age, "LiveAlone_shp", driver="ESRI Shapefile")
>>>>>>> bd8af6db5733e76c757a72a0e6db25b027874ef8
