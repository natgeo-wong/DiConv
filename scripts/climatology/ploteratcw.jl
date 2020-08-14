using DrWatson
@quickactivate "DiConv"

using ClimateERA
using GeoRegions
using NCDatasets

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

ds = NCDataset(datadir("erac5-TRPx0.25-tcw-sfc.nc"))
elon = ds["longitude"][:]
elat = ds["latitude"][:]
eavg = ds["average"][:]
edhr = ds["variability_diurnal"][:]
eitr = ds["variability_intraseasonal"][:]
close(ds)

init,eroot = erastartup(aID=2,dID=1)
rlsm,_,_ = eplotlsmgrid([20,-15,165,90],eroot["plot"],pID="TRP")

rlon,rlat,rinfo = regiongridvec([20,-15,165,90],elon,elat)
ravg = regionextractgrid(eavg,rinfo)
rdhr = regionextractgrid(edhr,rinfo)
ritr = regionextractgrid(eitr,rinfo)

lavg = ravg[rlsm.>0.5]; ldhr = rdhr[rlsm.>0.5]; litr = ritr[rlsm.>0.5]
lbin_dhr = fit(Histogram,(lavg,ldhr),(0:60,0:0.1:6)).weights
lbin_dhr = lbin_dhr./sum(lbin_dhr)*3600; lbin_dhr[lbin_dhr.==0] .= NaN
lbin_itr = fit(Histogram,(lavg,litr),(0:60,0:60)).weights
lbin_itr = lbin_itr./sum(lbin_itr)*3600; lbin_itr[lbin_itr.==0] .= NaN

savg = ravg[rlsm.<0.5]; sdhr = rdhr[rlsm.<0.5]; sitr = ritr[rlsm.<0.5]
sbin_dhr = fit(Histogram,(savg,sdhr),(0:60,0:0.1:6)).weights
sbin_dhr = sbin_dhr./sum(sbin_dhr)*3600; sbin_dhr[sbin_dhr.==0] .= NaN
sbin_itr = fit(Histogram,(savg,sitr),(0:60,0:60)).weights
sbin_itr = sbin_itr./sum(sbin_itr)*3600; sbin_itr[sbin_itr.==0] .= NaN

coord = readdlm(srcdir("GLB-i.txt"),comments=true,comment_char='#')
x = coord[:,1]; y = coord[:,2];

pplt.close(); arr = [[1,1],[2,2],[3,3],[4,5],[4,5],[6,7],[6,7]];
f,axs = pplt.subplots(arr,aspect=6,axwidth=6,sharey=0);

c1 = axs[1].contourf(elon,elat,eavg',levels=0:5:60,cmap="Blues");
axs[1].plot(x,y,c="k",lw=0.2)
axs[1].plot([60,270,270,60,60],[-15,-15,20,20,-15],c="w",lw=1)
axs[1].format(ylim=(-30,30),rtitle="Average",suptitle="Total Column Water / mm")
axs[1].colorbar(c1,loc="r")

c2 = axs[2].contourf(elon,elat,edhr',levels=2:0.25:5,cmap="Blues",extend="both")
axs[2].plot(x,y,c="k",lw=0.2)
axs[2].plot([60,270,270,60,60],[-15,-15,20,20,-15],c="w",lw=1)
axs[2].format(ylim=(-30,30),rtitle="Diurnal Variability",xlim=(0,360),xlocator=[0:60:360])
axs[2].colorbar(c2,loc="r")

c2 = axs[3].contourf(elon,elat,eitr',levels=0:5:40,cmap="Blues")
axs[3].plot(x,y,c="k",lw=0.2)
axs[3].plot([60,270,270,60,60],[-15,-15,20,20,-15],c="w",lw=1)
axs[3].format(ylim=(-30,30),rtitle="Intraseasonal Variability",xlim=(0,360),xlocator=[0:60:360])
axs[3].colorbar(c2,loc="r")

axs[4].pcolormesh(
    0:60,0:0.1:6,lbin_dhr',cmap="Blues",
    norm="segmented",
    levels=[0,1,2,5,10,20,50]
)
axs[4].plot([0,60],[0,6],c="k",lw=0.5)
axs[4].format(title="Land",ylabel="Diurnal Variability")

c3 = axs[5].pcolormesh(
    0:60,0:0.1:6,sbin_dhr',cmap="Blues",
    norm="segmented",
    levels=[0,1,2,5,10,20,50]
)
axs[5].plot([0,60],[0,6],c="k",lw=0.5)
axs[5].format(title="Ocean")
axs[5].colorbar(c3,loc="r",label="Density")

axs[6].pcolormesh(
    0:60,0:60,lbin_itr',cmap="Blues",
    norm="segmented",
    levels=[0,1,2,5,10,20,50]
)
axs[6].plot([0,60],[0,60],c="k",lw=0.5)
axs[6].format(title="Land",xlabel="Average",ylabel="Intraseasonal Variability")

c3 = axs[7].pcolormesh(
    0:60,0:60,sbin_itr',cmap="Blues",
    norm="segmented",
    levels=[0,1,2,5,10,20,50]
)
axs[7].plot([0,60],[0,60],c="k",lw=0.5)
axs[7].format(title="Ocean")
axs[7].colorbar(c3,loc="r",label="Density")

for ax in axs
    ax.format(abc=true,grid="on")
end

f.savefig(plotsdir("eratcw.png"),transparent=false,dpi=200)
