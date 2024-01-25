
# work directory must be changed to /Volumes/data_shared/UTCI_Intermediate_Files

# use the raster
library(raster)
library(stringr)

years <- as.list(2010:2019)
months <- as.list(1:12)
days <- as.list(1:31)

for(year in years){

	dir.create(as.character(year))

	dir <- paste("../universal_thermal_climate_index/",year, sep="")

	files <- list.files(path=dir, pattern="\\.nc$", recursive=TRUE)

	for(file in files){

		str_date <- str_extract(file, pattern="\\d{8}")

		if(file.exists(paste(year,"/",str_date,"_group_max.grd",sep="")) 
	       && file.exists(paste(year,"/",str_date,"_group_min.grd",sep=""))) 
	      next

		# load a nc file. one file one day. 

		b <- brick(paste(dir,file,sep="/"))

		b_list <- as.list(b)

		b_list$na.rm <- TRUE

		b_list$fun <- max 
		b_max <- do.call(mosaic,b_list)
		b_max <- b_max - 273.15

		b_list$fun <- min
		b_min <- do.call(mosaic,b_list)
		b_min <- b_min - 273.15

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

		writeRaster(b_group_max, filename=paste(year,"/",str_date,"_group_max.grd",sep=""), format="raster")
		writeRaster(b_group_min, filename=paste(year,"/",str_date,"_group_min.grd",sep=""), format="raster")

	}
}

