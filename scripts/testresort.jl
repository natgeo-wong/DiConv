using DrWatson
@quickactivate "DiConv"

using SAMTools

tdir = "/n/holyscratch01/kuang_lab/nwong/sam_tmp"
pdir = datadir()
fnc  = "RCE_128x128x64_32"
init,sroot = samstartup(tmppath=tdir,prjpath=pdir,config="RCETest",fname=fnc)
# smod,spar,stime = saminitialize(init,modID="m2D",parID="prcp")

samresort(init,sroot,modID="d2D",parID="t_sst")
samresort(init,sroot,modID="m2D",parID="prcp")
samresort(init,sroot,modID="m2D",parID="tcw")
samresort(init,sroot,modID="m2D",parID="swp")
samresort(init,sroot,modID="r2D",parID="sol_net_toa")
samresort(init,sroot,modID="s3D",parID="t_abs")
