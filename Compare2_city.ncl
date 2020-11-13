;*********************************************
; Ce script a pour but de d'extraire l'indice AA sur les points Majanje (lat =-9.55,lon= 16.34) 
;et Huambo ( lat = -12.77,lon = 15.73). 
; Et puis, ploter les series temporelles entre les 2 régions. 

;*********************************************
;
; these files are loaded by default in ncl v6.2.0 and newer
;load "$ncarg_root/lib/ncarg/nclscripts/csm/gsn_code.ncl"
;load "$ncarg_root/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;load "$ncldir/functions/load_env.ncl"



  indir =  "/home/mamour/Documents/MF_inter/DATA/" 


   infile1   = "mean_year.nc"
   f1       =  addfile (indir+ infile1, "r")  
   prcp     =  f1->mean_year
   
   
   infile2   = "Ano_accu.nc"
   f2       =  addfile (indir+ infile2, "r")  
   AA    =  f2->AA
   
   time = f2->time
   lat = f2->lat   
   lon = f2->lon  

   ntime = dimsizes(time)
   nlat  = dimsizes(lat)
   nlon  = dimsizes(lon)

   
   ; extract data Malanja and Huambo  
   data      = new((/2, ntime/),float)

    data(0,:) =  AA(:,{-9.55},{16.34})    ;Malanje
    data(1,:) =  AA(:,{-12.77},{15.73})   ;Huambo


 wks   = gsn_open_wks ("png","xy")                 ; send graphics to PNG file

;---Set plotting parameters

 res                   = True                      ; plot mods desired
 res@tiMainString      = "Comparaison between Malanje and Huambo"       ; add title
res@tiXAxisString     = "days"  
res@tiYAxisString     = "Anomalous Accumulation"
;
; Similiar resources are xyLineThicknessF and xyLineColor,
; which will affect all lines in the array.
;
 res@xyLineThicknesses = (/ 2,  2/)          ; make second line thicker
 res@xyLineColors      = (/"blue","red"/)          ; change line color


  res@pmLegendDisplayMode    = "Always"            ; turn on legend
  res@pmLegendSide           = "bottom"               ; Change location of 
  res@pmLegendParallelPosF   = .1                  ; move units right
  res@pmLegendOrthogonalPosF = -0.3                ; move units down
  res@pmLegendWidthF         = 0.1                ; Change width and
  res@pmLegendHeightF        = 0.1                ; height of legend.
  res@lgPerimOn              = False               ; turn off box around
  res@lgLabelFontHeightF     = .01                ; label font height
  res@xyExplicitLegendLabels = (/"Malanje","Huambo"/)         ; create explicit labels

  plot  = gsn_csm_xy (wks,AA&time,data*1000,res) ; create plot


      
