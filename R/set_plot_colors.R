library("RColorBrewer")
library("ggplot2")
myColors <- brewer.pal(8,"Set1")
names(myColors) <- c("truth","ash.hu","ash.n","ash.u","qvalue","locfdr","mixfdr.tnull","NPMLE")
colScale <- scale_colour_manual(name = "method",values = myColors)

