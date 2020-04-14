# Regression analysis for similarity-driven behavior experiments and features

setwd("/Users/michellegreene/Dropbox/work/functionEEG/encodeDecodeALL/data/")
library(R.matlab)

# load human distances
behavior <- readMat("whiteDataSimilarityExps.mat")
behavior <- behavior$whiteData
behavior <- behavior[,-1] # no need for dummy column

# load features
features <- readMat("finalFeaturesZ.mat")
features <- features$finalFeaturesZ
features <- features[,-1] # no need for dummy column

# create model for each experiment
# create data frame
dataFrame <- as.data.frame(features)
dataFrame$orientation <- behavior[,1]
dataFrame$texture <- behavior[,2]
dataFrame$object <- behavior[,3]
dataFrame$affordance <- behavior[,4]
dataFrame$lexical <- behavior[,5]

# run regressions
orientationModel <- lm(orientation ~ V1+V2+V3+V4+V5+V6+V7+V8+V9, data=dataFrame)
textureModel <- lm(texture ~ V1+V2+V3+V4+V5+V6+V7+V8+V9, data=dataFrame)
objectModel <- lm(object ~ V1+V2+V3+V4+V5+V6+V7+V8+V9, data=dataFrame)
affordanceModel <- lm(affordance ~ V1+V2+V3+V4+V5+V6+V7+V8+V9, data=dataFrame)
lexicalModel <- lm(lexical ~ V1+V2+V3+V4+V5+V6+V7+V8+V9, data=dataFrame)