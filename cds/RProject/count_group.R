# 注意： work directory must be changed to /Volumes/data_shared/UTCI_Intermediate_Files_Group

# 算法第二步，按年计算每个组别的个数（max and min）

# use the raster
library(raster)
library(stringr)

years <- as.list(2010:2019)

for(year in years){
  
  # dir 是算法第一步输出结果的目录中对应当前计算年份的文件夹
  dir <- paste("../UTCI_Intermediate_Files",year, sep="/")
  file_g_max = paste(year,"_g_max.grd",sep="")
  file_g_min = paste(year,"_g_min.grd",sep="")
  if(!file.exists(file_g_max)){
    
    max_files <- list.files(path=dir, pattern="\\max.grd$", recursive=TRUE)
    
    # 初始化10个raster的列表，分别对应1-10组
    # 遍历每年的数据，按组累加到数据上
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
    writeRaster(b,filename=file_g_max, format="raster")
  }
  
  if(!file.exists(file_g_min)) {
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
    writeRaster(b,filename=file_g_min, format="raster")
  }
  
}

