
# gpw <- brick(file.choose())
# gpw must be cropped 
# gpw <- crop(gpw,extent(-180,180,-60,90))

# library(xlsx)
# countries <- read.xlsx(file.choose(),sheetIndex = 1)

# library(readxl)
# library(writexl)
# wpp <- read_xlsx(file.choose(),skip=16,na="...")

df <- data.frame(country_code=character(),
                  country=character(),
                  year=character(),
                  age=character(),
                  utci_group=character(),
                  exposure_weight_mean_max=double(),
                  exposure_weight_mean_min=double(),
                  stringsAsFactors = FALSE)

years <- 2010:2019


# 计算2010年每个栅格内部各年龄段人口相对于其总人口的比例, f_gpw_2 0-4和f_gpw_15 65+
f_gpw_2 <- gpw[[2]]/gpw[[1]]
f_gpw_15 <- gpw[[15]]/gpw[[1]]

for(year in years){
  dir <- "~/Downloads/UTCI_Intermediate_Files_Group"
  
  g_max <- brick(file.path(dir,paste(year,"_g_max.grd",sep = "")))
  g_min <- brick(file.path(dir,paste(year,"_g_min.grd",sep = "")))
  
  g_max <- setExtent(g_max,extent(-180,180,-60.25,90),keepres = TRUE)
  g_min <- setExtent(g_min,extent(-180,180,-60.25,90),keepres = TRUE)
  
  g_max <- crop(g_max,extent(-180,180,-60,90))
  g_min <- crop(g_min,extent(-180,180,-60,90))
  
  for (i in 1:183) {
    country_code = countries$code[i]
    country_name = countries$WPP.Country[i]
    
    wpp_2010 <- filter(wpp,wpp$`Country code`==country_code,wpp$`Reference date (as of 1 July)`=="2010")
    wpp_ <- filter(wpp,wpp$`Country code`==country_code,wpp$`Reference date (as of 1 July)`==year)
    
    wpp_2010_sum <- sum(wpp_2010[9:29])
    wpp_sum <- sum(wpp_[9:29])
    
    r_0_4 <- as.double((wpp_[9]/wpp_sum)/(wpp_2010[9]/wpp_2010_sum))
    r_65_plus <- as.double((sum(wpp_[22:29])/wpp_sum)/(sum(wpp_2010[22:29])/wpp_2010_sum))
    
    f_wpp_year_country_total <- as.double(wpp_sum/wpp_2010_sum)
    
    wpp_0_4 <- wpp_[9]
    wpp_0_4 <- wpp_0_4*1000
    
    wpp_65_plus <- sum(wpp_[22:29])
    wpp_65_plus <- wpp_65_plus*1000
    
    wpp_0_4_65_plus <- sum(wpp_[22:29])+wpp_[9]
    wpp_0_4_65_plus <- wpp_0_4_65_plus*1000
    
    mask <- gpw[[21]]
    
    mask[mask!=country_code] <- NA
    mask[mask==country_code] <- 1
    
    # gpw_2 <- mask(gpw[[2]],mask,maskValue=NA)
    # gpw_15 <- mask(gpw[[15]],mask,maskValue=NA)
    
    gpw_2 <- mask(f_gpw_2,mask,maskValue=NA)
    gpw_15 <- mask(f_gpw_15,mask,maskValue=NA)
    
    gpw_1 <- mask(gpw[[1]],mask,maskValue=NA)
    gpw_1 <- gpw_1*f_wpp_year_country_total
    
    gpw_2 <- gpw_1*r_0_4*f_gpw_2
    gpw_15 <- gpw_1*r_65_plus*f_gpw_15
    
    for(g in 1:10){
      
      t_max <- mask(g_max[[g]],mask,maskValue=NA)
      t_min <- mask(g_min[[g]],mask,maskValue=NA)
      
      t_max_both <- t_max*(gpw_2+gpw_15)
      t_min_both <- t_min*(gpw_2+gpw_15)
      
      t_max_0_4 <- t_max*(gpw_2)
      t_min_0_4 <- t_min*(gpw_2)
      
      t_max_65_plus <- t_max*gpw_15
      t_min_65_plus <- t_min*gpw_15
      
      #t_max <- overlay(t_max,(gpw_2 + gpw_15),fun=function(x,y) x*y)
      #t_min <- overlay(t_min,(gpw_2 + gpw_15),fun=function(x,y) x*y)
      
      #t_max <- (gpw_2 + gpw_15) * t_max
      #t_min <- (gpw_2 + gpw_15) * t_min
      
      t_max_sum_both <- cellStats(t_max_both,'sum')/wpp_0_4_65_plus
      t_min_sum_both <- cellStats(t_min_both,'sum')/wpp_0_4_65_plus
      
      t_max_sum_0_4 <- cellStats(t_max_0_4,'sum')/wpp_0_4
      t_min_sum_0_4 <- cellStats(t_min_0_4,'sum')/wpp_0_4
      
      t_max_sum_65_plus <- cellStats(t_max_65_plus,'sum')/wpp_65_plus
      t_min_sum_65_plus <- cellStats(t_min_65_plus,'sum')/wpp_65_plus
      
      df[nrow(df)+1,] <- c(country_code,country_name,year,"both",g,t_max_sum_both,t_min_sum_both)
      df[nrow(df)+1,] <- c(country_code,country_name,year,"0-4",g,t_max_sum_0_4,t_min_sum_0_4)
      df[nrow(df)+1,] <- c(country_code,country_name,year,"65+",g,t_max_sum_65_plus,t_min_sum_65_plus)
      
    }
    
  }

}

write_xlsx(df,path=paste("country_year_utci_group_exposure_mean_",format(Sys.time(),"%Y%m%d%H%M%S"),".xlsx",sep=""))

