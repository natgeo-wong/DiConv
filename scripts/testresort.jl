using DrWatson
@quickactivate "DiConv"

using SAMTools

tdir = "/n/holyscratch01/kuang_lab/nwong/sam_tmp"
pdir = datadir()
fnc  = "RCE_128x128x64_32"
init,sroot = samstartup(tmppath=tdir,prjpath=pdir,config="RCETest",fname=fnc)
