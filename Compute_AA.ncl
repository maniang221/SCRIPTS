;*********************************************
; conversion short to float
; Calculer les précipitations moyennes journalières sur la période 1981-2010
;  
;*********************************************
;
; these files are loaded by default in ncl v6.2.0 and newer
load "$ncarg_root/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$ncarg_root/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$ncldir/functions/load_env.ncl"


  indir =  "/home/mamour/Documents/MF_inter/DATA/DAYS/" 

  nlat  = 41
  nlon  = 21
  ntime = 366

  ydeb  = 1981
  yfin  = 2010

  an     = ispan(ydeb,yfin,1)
  nyear  = dimsizes(an)
  date   = yyyymmdd_time(ydeb, yfin, "integer")
  ndays  = dimsizes(date)

  nhours = ndays*24

  period = new((/ndays, nlat, nlon/),float)

  period!0 = "time"
  period&time = date 
  
  do k = 0 , nyear-1 
      ;k = 1
       infile   = "daily_" + an(k)+".nc"
       f        =  addfile (indir+ infile, "r")  
       tp_day   =  f->tp_day
       time     =  f->time
       lat      =  f->lat
       lon      =  f->lon
       
     
       period({time}, :,:)  =   tp_day
       delete(f)
       delete(tp_day)
       delete(time)
    
 end do 
    
 date_count = yyyymmdd_to_yyyyddd(date)


  period!0    = "time"
  period&time = date_count
  period!1    = "lat"
  period&lat  =  lat
  period!2    = "lon"
  period&lon  =  lon



; Calcul de précipitation journalières entre 1981 et 2010

  climat_day = clmDayTLL(period, date_count)

  climat_day!0    = "time"
  climat_day&time = ispan(0,365,1)
  climat_day!1    = "lat"
  climat_day&lat  =  lat
  climat_day!2    = "lon"
  climat_day&lon  =  lon

 print(max(climat_day))


; Moyenne annuelle des precipitations  
 
 mean_year = dim_avg_n_Wrap(climat_day,0)

 mean_year!0    = "lat"
 mean_year&lat  =  lat
 mean_year!1    = "lon"
 mean_year&lon  =  lon



; Calcul Anomalus Accumalation (AA) 

 AA = new((/366, nlat, nlon/),float)
 do l = 0 , 365
    AA(l,:,:) = climat_day(l,:,:) - mean_year
 end do 

 
 AA!0    = "time"
 AA&time = ispan(0,365,1)
 AA!1    = "lat"
 AA&lat  =  lat
 AA!2    = "lon"
 AA&lon  =  lon

; AA moyenne entre 1981 - 2010

  AA_mean = dim_avg_n_Wrap(AA,0)

  AA_mean!0    = "lat"
  AA_mean&lat  =  lat
  AA_mean!1    = "lon"
  AA_mean&lon  =  lon



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Sauvegarde des données en .nc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  outdir  =  "/home/mamour/Documents/MF_inter/DATA/"
  outfile1 =  "climat_day.nc"

  mm   = systemfunc("rm "+ outdir + outfile1)
    gout = addfile(outdir + outfile1,"c")
    gout->climat_day=climat_day

  outfile2 =  "mean_year.nc"
  ss   = systemfunc("rm "+ outdir + outfile2)
  cout = addfile(outdir + outfile2,"c")
  cout->mean_year=mean_year


  outfile3 =  "Ano_accu.nc"
  aa   = systemfunc("rm "+ outdir + outfile3)
  Aout = addfile(outdir + outfile3,"c")
  Aout->AA=AA


  outfile4 =  "Mean_Ano_accu.nc"
  Maa   = systemfunc("rm "+ outdir + outfile4)
  MAout = addfile(outdir + outfile4,"c")
  MAout->AA_mean=AA_mean





