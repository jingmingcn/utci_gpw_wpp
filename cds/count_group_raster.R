# work directory must be changed to /Volumes/data_shared/UTCI_Intermediate_Files_Group

# use the raster
library(raster)
library(stringr)


years <- as.list(2010:2019)

for(year in years){

	dir.create(as.character(year))

	dir <- paste("../UTCI_Intermediate_Files",year, sep="/")

	if(file.exists(paste(year,"/","group_max.grd",sep=""))){

		max_files <- list.files(path=dir, pattern="\\max.grd$", recursive=TRUE)

		max_r <- vector(mode="list",10)
		for(i in 1:length(max_files)){
			r <- raster(paste(dir,max_files[i],sep="/"))
			if(i == 1){
				for(j in 1:10){
					t <- r
					t[t!=j] <- 0
					t[t==j] <- 1
					max_r[[j]] <- t
				}
			}
			else{
				for(j in 1:10){
					t <- r
					t[t!=j] <- 0
					t[t==j] <- 1
					max_r[[j]] <- max_r[[j]] + t
				}
			}
		}

		b <- stack(as.list(max_r))
		b <- brick(b)
		writeRaster(b,filename=paste(year,"/","group_max.grd",sep=""), format="raster")
	}

	if(file.exists(paste(year,"/","group_min.grd",sep=""))) {
		min_files <- list.files(path=dir, pattern="\\min.grd$", recursive=TRUE)

		min_r <- vector(mode="list",10)
		for(i in 1:length(min_files)){
			r <- raster(paste(dir,min_files[i],sep="/"))
			if(i == 1){
				for(j in 1:10){
					t <- r
					t[t!=j] <- 0
					t[t==j] <- 1
					min_r[[j]] <- t
				}
			}
			else{
				for(j in 1:10){
					t <- r
					t[t!=j] <- 0
					t[t==j] <- 1
					min_r[[j]] <- min_r[[j]] + t
				}
			}
		}

		b <- stack(as.list(min_r))
		b <- brick(b)
		writeRaster(b,filename=paste(year,"/","group_min.grd",sep=""), format="raster")
	}

}

