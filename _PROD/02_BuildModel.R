# ----------------------------------------------------------------------------------------
# R Script to train the Deep Learning model on Financial Asset Time Series Data
# ----------------------------------------------------------------------------------------
# ## Manually selected data is in the matrix with label of 6 classes
# ----------------------------------------------------------------------------------------
#
# Supervised Deep Learning Classification Modelling
#
# load libraries to use and custom functions from package lazytrade
library(readr)
library(magrittr)
library(dplyr)
library(h2o)
library(lazytrade)

#path to user repo:
#!!!Change this path!!! 
path_user <- "E:/trading/Git/R_markettype"
#!!!Change this path!!!

chart_period <- 5
#!!!Execute code below line by line

#absolute path to store model objects (useful when scheduling tasks)
path_model <- file.path(path_user, "_MODELS")
path_data <- file.path(path_user, "_DATA")

# check if the directory exists or create
if(!dir.exists(path_model)){dir.create(path_model)}
if(!dir.exists(path_data)){dir.create(path_data)}

#### Manually Selected data... =================================================
# data stored in the lazytrade package
data(macd_ML2)

# Market Periods
# 1. Bull normal, BUN
# 2. Bull volatile, BUV
# 3. Bear normal, BEN
# 4. Bear volatile, BEV
# 5. Sideways quiet, RAN
# 6. Sideways volatile, RAV

# write data to the _DATA folder
if(!file.exists(file.path(path_data, "macd_ML2.rds")))
  {
   #write sample file 
   macd_ML2 %>% write_rds(file.path(path_data, "macd_ML2.rds"))
} else {
  #read existing file 
  macd_ML2 <- read_rds(file.path(path_data, "macd_ML2.rds"))
  }

#### Fitting Deep Learning Net =================================================
# start h2o virtual machine
h2o.init()

# use function from the lazytrade package:
macd_ML2 %>% mt_make_model(num_bars = 64,
                           timeframe = chart_period,
                           path_model = path_model,
                           path_data = path_data,
                           activate_balance = TRUE)

# shutdown the virtual machine
h2o.shutdown(prompt = F)

#### End