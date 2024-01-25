# 算法第一步：计算每天utci值的最大和最小值，计算结果每天对应保存到一个文件，
# 文件名用日期和后缀(_group_max.grd and _group_min.grd)表示

# 注意：切换当前工作目录到与universal_thermal_climate_index平级的一个目录下面，
# 如：UTCI_Intermediate_Files

# use the raster
library(raster)
library(stringr)

years <- as.list(2010:2020)
months <- as.list(1:12)
days <- as.list(1:31)

# utci数据保存在universal_thermal_climate_index目录下面，按年遍历UTCI数据
for(year in years){
  
  # 因为算法第二步要按年统计个数，所以每年一个文件夹
  dir.create(as.character(year))
  
  # dir 是utci对应当前计算年份的目录，
  dir <- paste("../universal_thermal_climate_index/",year, sep="")
  
  files <- list.files(path=dir, pattern="\\.nc$", recursive=TRUE)
  
  for(file in files){
    
    str_date <- str_extract(file, pattern="\\d{8}")
    
    # 算法执行过程可能会中断，所以跳过已经完成计算的数据
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
    
    # 下面两行是这个算法过程的核心，把10个区间划分到10个组别
    b_group_max <- reclassify(b_max, g_m, right=FALSE)
    b_group_min <- reclassify(b_min, g_m, right=FALSE)
    
    writeRaster(b_group_max, filename=paste(year,"/",str_date,"_group_max.grd",sep=""), format="raster")
    writeRaster(b_group_min, filename=paste(year,"/",str_date,"_group_min.grd",sep=""), format="raster")
    
  }
}

