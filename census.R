#install via downloading package

install.packages("cancensus")

library(cancensus)
library(tidyverse)

options(cancensus.api_key = "CensusMapper_330652d5ae9c2ccaafc7883a06fb3967")
options(cancensus.cache_path = "custom cache path")

set_api_key(<CensusMapper_330652d5ae9c2ccaafc7883a06fb3967>, install = TRUE)


# install.packages("devtools")

devtools::install_github("mountainmath/cancensus")

library(cancensus)

options(cancensus.api_key = "CensusMapper_330652d5ae9c2ccaafc7883a06fb396")
options(cancensus.cache_path = "custom cache path")

