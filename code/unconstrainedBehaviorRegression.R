# Regression analysis for unconstrained behavior

setwd("/Users/michellegreene/Dropbox/work/functionEEG/encodeDecodeALL/data/")
library(R.matlab)

# load human distances
behavior <- readMat("humanDist.mat")
behavior <- behavior$humanDist

# load features
features <- readMat("finalFeaturesZ.mat")
features <- features$finalFeaturesZ
features <- features[,-1] # no need for dummy column

# create data frame
dataFrame <- as.data.frame(features)
dataFrame$behavior <- t(behavior)

# run regression
model <- lm(behavior ~ ., data=dataFrame)