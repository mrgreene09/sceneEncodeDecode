par(mfrow=c(5,1))

w <- which(data$Experiment=="Orientation")
wData <- data[w,]
names <- c("Orientation", "Texture", "Function", "Object", "Lexical")
theseMeans <- wData$Point
barCenters <- barplot(height=theseMeans,
                      ylim=c(-.05, .1),
                      names.arg = names,
                      col = ifelse(wData$Feature=="Wavelet","blue","gray"),
                      ylab = "Beta",
                      main="Orientation"
)
segments(barCenters, wData$Lower, barCenters, wData$Upper, lwd = 1.5)

t <- which(data$Experiment=="Texture")
tData <- data[t,]
names <- c("Orientation", "Texture", "Function", "Object", "Lexical")
theseMeans <- tData$Point
barCenters <- barplot(height=theseMeans,
                      ylim=c(-.05, .1),
                      names.arg = names,
                      col = ifelse(wData$Feature=="Texture","blue","gray"),
                      ylab = "Beta",
                      main="Texture"
)
segments(barCenters, tData$Lower, barCenters, tData$Upper, lwd = 1.5)

f <- which(data$Experiment=="Function")
fData <- data[f,]
names <- c("Orientation", "Texture", "Function", "Object", "Lexical")
theseMeans <- fData$Point
barCenters <- barplot(height=theseMeans,
                      ylim=c(-.05, .1),
                      names.arg = names,
                      col = ifelse(wData$Feature=="Functions","blue","gray"),
                      ylab = "Beta",
                      main="Function"
)
segments(barCenters, fData$Lower, barCenters, fData$Upper, lwd = 1.5)

o <- which(data$Experiment=="Object")
oData <- data[o,]
names <- c("Orientation", "Texture", "Function", "Object", "Lexical")
theseMeans <- oData$Point
barCenters <- barplot(height=theseMeans,
                      ylim=c(-.05, .1),
                      names.arg = names,
                      col = ifelse(oData$Feature=="Objects","blue","gray"),
                      ylab = "Beta",
                      main="Object"
)
segments(barCenters, oData$Lower, barCenters, oData$Upper, lwd = 1.5)

l <- which(data$Experiment=="Lexical")
lData <- data[l,]
names <- c("Orientation", "Texture", "Function", "Object", "Lexical")
theseMeans <- lData$Point
barCenters <- barplot(height=theseMeans,
                      ylim=c(-.05, .1),
                      names.arg = names,
                      col = ifelse(wData$Feature=="Lexical","blue","gray"),
                      ylab = "Beta",
                      main="Lexical"
)
segments(barCenters, lData$Lower, barCenters, lData$Upper, lwd = 1.5)