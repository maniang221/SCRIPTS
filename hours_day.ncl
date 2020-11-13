;******************************************************************************************************
; conversion short to float
; Calcul de cumul de précipitations journalières à partir des données horaires. 
;********************************************************************************************************
;
; these files are loaded by default in ncl v6.2.0 and newer
load "$ncarg_root/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$ncarg_root/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$ncldir/functions/load_env.ncl"



  indir  =  "/home/mamour/Documents/MF_inter/DATA/HOUR/"
  outdir =  "/home/mamour/Documents/MF_inter/DATA/DAYS/" 

  nlat = 41
  nlon = 21

  ydeb = 1981
  yfin = 2010

  an    = ispan(ydeb,yfin,1)
  nyear = dimsizes(an)
  

  do k = 0 , nyear-1 

;k= 0
    
     date   = yyyymmdd_time(an(k), an(k), "integer")
     ndays  = dimsizes(date)
     nhours = ndays*24
     tp_day = new((/ndays, nlat, nlon/),float)
  
     infile  =  an(k) + ".nc"
     outfile = "daily_" + an(k)+".nc"

     f    =  addfile (indir+ infile, "r")  
     tp   =  short2flt( f->tp)
     lat  =  f->latitude
     lon  =  f->longitude
     
     
     
    

     tp!0 = "time"

     if (k.eq.0) then 
        tp&time = ispan(1,nhours-1,1)

        tp_day(0,:,:) = dim_sum_n_Wrap(tp({1 : 23}, :, :),0)    
       
        do i = 1, ndays-1
           j = i*24
           tp_day(i,:,:) = dim_sum_n_Wrap(tp({j : j+23}, :, :),0)
        end do 

     else 
        
        tp&time = ispan(0,nhours-1,1)

        do i = 0, ndays-1
           j = i*24
           tp_day(i,:,:) = dim_sum_n_Wrap(tp({j : j+23}, :, :),0)
        end do 

    end if 

    tp_day!0 = "time"
    tp_day&time = date ; ispan(0,ndays-1,1)
    tp_day!1   = "lat"
    tp_day&lat =lat
    tp_day!2   = "lon"
    tp_day&lon =lon
    
     print(an(k))
     print(min(tp_day))

;===============================================================

    mm   = systemfunc("rm "+ outdir + outfile)
    gout = addfile(outdir + outfile,"c")
    gout->tp_day=tp_day

    delete(f)
    delete(tp)
    delete(tp_day)
    delete(infile)
    delete(outfile)
    delete(date)
    delete(ndays)
    delete(nhours)

  end do 

