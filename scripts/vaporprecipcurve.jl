using DrWatson
@quickactivate "DiConv"

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

include(srcdir("common.jl"))
include(srcdir("PEcurve.jl"))

tdir = "/n/holyscratch01/kuang_lab/nwong/sam_tmp"
pdir = datadir("SAM")
fnc  = "RCE_*"

init,sroot = samstartup(tmppath=tdir,prjpath=pdir,config="control-dynamicSST-2",fname=fnc)

prcp = collate(init,sroot,modID="m2D",parID="prcp")
tcwv = collate(init,sroot,modID="m2D",parID="tcw")
prnd,trnd = randomselect(1000000,prcp[:,:,1000:end],tcwv[:,:,1000:end])
tvec = 10:0.5:90; pvec,pstd = bretherthoncurve(prcp,tcwv,tvec)

pplt.close(); f,axs = pplt.subplots(nrows=1,axwidth=4,aspect=2,sharey=0)

axs[1].plot(tvec,pvec./24)
axs[1].plot(tvec,(pvec.-pstd)./24,linestyle=":",c="r")
axs[1].plot(tvec,(pvec.+pstd)./24,linestyle=":",c="r")
axs[1].format(
    ylabel=L"Precipitation Rate / mm hr$^{-1}$",
    xlabel="Total Column Water / mm",
    xlim=(40,80)
)

f.savefig(plotsdir("tcwvVprcp.png"),transparent=false,dpi=200)
