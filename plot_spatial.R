# ce script a pour but de travers la repartition spatio-temporelle de 
# la moyenne des précipitations et de l'indice Moyenne AA des precipiatations

# Nbs Ce scripts a été fait sur ncl mais à cause de probleme de resoources les graphes ne sont pas plotter
# correctement don j'ai fai recours à R.  

library(ncdf4)
library(raster)

filename = c("mean_year.nc", "Mean_Ano_accu.nc")
param    = c("mean_year", "AA_mean")

title    = c("Mean annuel precipitation","Anamalous accumulation")

 for (i in 1:2){
    
    a        = raster(filename[i], varname=param[i])
   
    png(paste0(param[i],".png"))
    plot(a*1000, xlab="lon", ylab="lat", main = title[i])
    library(maptools)
    data("wrld_simpl")
    plot(wrld_simpl, add = T)
  dev.off()  
 }










