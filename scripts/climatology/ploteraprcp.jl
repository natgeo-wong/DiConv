using DrWatson
@quickactivate "DiConv"

using ClimateERA
using GeoRegions
using NCDatasets

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

ds = NCDataset(datadir("erac5-TRPx0.25-prcp_tot-sfc.nc"))
elon = ds["longitude"][:]
elat = ds["latitude"][:]
eavg = ds["average"][:]*1000
edhr = ds["variability_diurnal"][:]*1000
close(ds)

init,eroot = erastartup(aID=2,dID=1)
rlsm,_,_ = eplotlsmgrid([20,-15,270,60],eroot["plot"],pID="TRP")

rlon,rlat,rinfo = regiongridvec([20,-15,270,60],elon,elat)
ravg = regionextractgrid(eavg,rinfo)
rdhr = regionextractgrid(edhr,rinfo)

lavg = ravg[rlsm.>0.5]; ldhr = rdhr[rlsm.>0.5]
lbin = fit(Histogram,(lavg,ldhr),(0:0.005:0.6,0:0.05:6)).weights; lbin = lbin./maximum(lbin)
lbin[lbin.==0] .= NaN

savg = ravg[rlsm.<0.5]; sdhr = rdhr[rlsm.<0.5]
sbin = fit(Histogram,(savg,sdhr),(0:0.005:0.6,0:0.05:6)).weights; sbin = sbin./maximum(sbin)
sbin[sbin.==0] .= NaN

coord = readdlm(srcdir("GLB-i.txt"),comments=true,comment_char='#')
x = coord[:,1]; y = coord[:,2];

pplt.close(); arr = [[1,1],[2,2],[3,4],[3,4]];
f,axs = pplt.subplots(arr,aspect=6,axwidth=6,sharey=0);

c1 = axs[1].contourf(elon,elat,eavg',levels=0:0.05:0.5,cmap="drywet",extend="max");
axs[1].plot(x,y,c="k",lw=0.2)
axs[1].plot([60,270,270,60,60],[-15,-15,20,20,-15],c="w",lw=1)
axs[1].format(ylim=(-30,30),rtitle="Average",suptitle=L"Precipitation Rate / mm hr$^{-1}$")
axs[1].colorbar(c1,loc="r")

c2 = axs[2].contourf(elon,elat,edhr',levels=0:0.5:5,cmap="drywet")
axs[2].plot(x,y,c="k",lw=0.2)
axs[2].plot([60,270,270,60,60],[-15,-15,20,20,-15],c="w",lw=1)
axs[2].format(ylim=(-30,30),rtitle="Diurnal Variability",xlim=(0,360),xlocator=[0:60:360])
axs[2].colorbar(c2,loc="r")

axs[3].pcolormesh(
    0:005:0.6,0:0.05:6,lbin',cmap="Blues",
    norm="segmented",
    levels=[0,0.01,0.1,0.2,0.5,0.9,1]
); axs[3].format(title="Land",xlabel="Yearly Total",ylabel="Diurnal Variability")
c3 = axs[4].pcolormesh(
    0:0.005:0.6,0:0.05:6,sbin',cmap="Blues",
    norm="segmented",
    levels=[0,0.01,0.1,0.2,0.5,0.9,1]
); axs[4].format(title="Ocean")
axs[4].colorbar(c3,loc="r",label="Normalized Frequency")

for ax in axs
    ax.format(abc=true,grid="on")
end

f.savefig(plotsdir("eraprcp.png"),transparent=false,dpi=200)
