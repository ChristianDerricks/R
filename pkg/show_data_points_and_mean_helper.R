source('pkg/initalize.R', local = TRUE)
source('pkg/show_data_points_and_mean.R', local = TRUE)

set.seed(1)
N = 50

data1 = rnorm(N)
data1
groups1 = c(rep(1, N/2), rep(2, N/2))
groups1
identical(NULL, dim(groups1))
length(groups1)

data2 = cbind(data1[1:25], data1[26:50])
data2
groups2 = cbind(rep(1, N/2), rep(2, N/2))
groups2
identical(NULL, dim(groups2))
length(groups2)

#y = c(as.numeric(data[,1]), as.numeric(data[,2]))
data = data2
groups = groups2

horizontalTF = T

h = boxplot(data~groups, plot = FALSE)
boxplot(data~groups, outline=TRUE, notch=TRUE, varwidth=TRUE, horizontal=horizontalTF)
offset = 0

show_data_points_and_mean(data, groups, horizontalTF, offset)
