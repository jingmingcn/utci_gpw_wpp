
# use the raster
library(raster)

# load a nc file. one file per day. 
b <- brick(file.choose())

b_list <- as.list(b)

b_list$na.rm <- TRUE

b_list$fun <- max 
b_max <- do.call(mosaic,b_list)

b_list$fun <- min
b_min <- do.call(mosaic,b_list)

g_m <- c(
	-Inf,-40,1,
	-40,-27,2,
	-27,-13,3,
	-13,0,4,
	0,9,5,
	9,26,6,
	26,32,7,
	32,38,8,
	38,46,9,
	46,Inf,10
	)

g_m <- matrix(g_m,ncol=3,byrow=TRUE)

b_group_max <- reclassify(b_max, g_m, right=FALSE)
b_group_min <- reclassify(b_min, g_m, right=FALSE)


