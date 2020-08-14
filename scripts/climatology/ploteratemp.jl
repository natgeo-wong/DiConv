using DrWatson
@quickactivate "DiConv"

using ClimateERA
using GeoRegions
using NCDatasets

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

ds = NCDataset(datadir("erac5-TRPx0.25-t_sfc-sfc.nc"))
elon = ds["longitude"][:]
elat = ds["latitude"][:]
leavg = ds["average"][:]
ledhr = ds["variability_diurnal"][:]
leitr = ds["variability_intraseasonal"][:]
close(ds)

init,eroot = erastartup(aID=2,dID=1)
rlsm,_,_ = eplotlsmgrid([20,-15,270,60],eroot["plot"],pID="TRP")

rlon,rlat,rinfo = regiongridvec([20,-15,270,60],elon,elat)
ravg = regionextractgrid(leavg,rinfo)
rdhr = regionextractgrid(ledhr,rinfo)
ritr = regionextractgrid(leitr,rinfo)

lavg = ravg[rlsm.>0.5]; ldhr = rdhr[rlsm.>0.5]; litr = ritr[rlsm.>0.5];
lbin_dhr = fit(Histogram,(lavg,ldhr),(280:0.5:305,0:0.1:8)).weights
lbin_dhr = lbin_dhr./sum(lbin_dhr)*4000; lbin_dhr[lbin_dhr.==0] .= NaN
lbin_itr = fit(Histogram,(lavg,litr),(280:0.5:305,0:0.1:8)).weights
lbin_itr = lbin_itr./sum(lbin_itr)*4000; lbin_itr[lbin_itr.==0] .= NaN

ds = NCDataset(datadir("erac5-TRPx0.25-t_sst-sfc.nc"))
elon = ds["longitude"][:]
elat = ds["latitude"][:]
seavg = ds["average"][:]
sedhr = ds["variability_diurnal"][:]
seitr = ds["variability_intraseasonal"][:]
close(ds)

rlon,rlat,rinfo = regiongridvec([20,-15,270,60],elon,elat)
ravg = regionextractgrid(seavg,rinfo)
rdhr = regionextractgrid(sedhr,rinfo)
ritr = regionextractgrid(seitr,rinfo)

savg = ravg[.!isnan.(ravg)]; sdhr = rdhr[.!isnan.(rdhr)]; sitr = ritr[.!isnan.(ritr)]
sbin_dhr = fit(Histogram,(savg,sdhr),(280:0.5:305,0:0.004:0.2)).weights
sbin_dhr = sbin_dhr./sum(sbin_dhr)*2500; sbin_dhr[sbin_dhr.==0] .= NaN
sbin_itr = fit(Histogram,(savg,sitr),(280:0.5:305,0:0.1:8)).weights
sbin_itr = sbin_itr./sum(sbin_itr)*2500; sbin_itr[sbin_itr.==0] .= NaN

coord = readdlm(srcdir("GLB-i.txt"),comments=true,comment_char='#')
x = coord[:,1]; y = coord[:,2];

pplt.close(); arr = [[1,1],[2,2],[3,3],[4,5],[4,5],[6,7],[6,7]];
f,axs = pplt.subplots(arr,aspect=6,axwidth=6,sharey=0);

c1 = axs[1].contourf(elon,elat,leavg',levels=295:305,extend="both");
axs[1].contourf(elon,elat,seavg',levels=295:305,extend="both")
axs[1].plot(x,y,c="k",lw=0.2)
axs[1].plot([60,270,270,60,60],[-15,-15,20,20,-15],c="w",lw=1)
axs[1].format(ylim=(-30,30),rtitle="Average",suptitle="Surface Temperature / K")
axs[1].colorbar(c1,loc="r")

c2 = axs[2].contourf(
    elon,elat,ledhr',norm="segmented",
    levels=[0.01,0.02,0.05,0.1,0.2,0.5,1,2,5,10],extend="both"
)
axs[2].contourf(
    elon,elat,sedhr',norm="segmented",
    levels=[0.01,0.02,0.05,0.1,0.2,0.5,1,2,5,10],extend="both"
)
axs[2].plot(x,y,c="k",lw=0.2)
axs[2].plot([60,270,270,60,60],[-15,-15,20,20,-15],c="w",lw=1)
axs[2].format(ylim=(-30,30),rtitle="Diurnal Variability",xlim=(0,360),xlocator=[0:60:360])
axs[2].colorbar(c2,loc="r")

c2 = axs[3].contourf(
    elon,elat,leitr',norm="segmented",
    levels=[0.1,0.2,0.5,1,2,5,10],extend="both"
)
axs[3].contourf(
    elon,elat,seitr',norm="segmented",
    levels=[0.1,0.2,0.5,1,2,5,10],extend="both"
)
axs[3].plot(x,y,c="k",lw=0.2)
axs[3].plot([60,270,270,60,60],[-15,-15,20,20,-15],c="w",lw=1)
axs[3].format(ylim=(-30,30),rtitle="Intraseasonal Variability",xlim=(0,360),xlocator=[0:60:360])
axs[3].colorbar(c2,loc="r")

axs[4].pcolormesh(
    280:0.5:305,0:0.1:8,lbin_dhr',cmap="Reds",
    norm="segmented",
    levels=[0,1,10,20,50,90,100]
)
axs[4].format(title="Land",ylabel="Diurnal Variability")

c3 = axs[5].pcolormesh(
    280:0.5:305,0:0.004:0.2,sbin_dhr',cmap="Reds",
    norm="segmented",
    levels=[0,1,10,20,50,90,100]
)
axs[5].format(title="Ocean")
axs[5].colorbar(c3,loc="r",label="Density")

axs[6].pcolormesh(
    280:0.5:305,0:0.1:8,lbin_itr',cmap="Reds",
    norm="segmented",
    levels=[0,1,10,20,50,90,100]
)
axs[6].format(title="Land",xlabel="Average",ylabel="Intraseasonal Variability")

c3 = axs[7].pcolormesh(
    280:0.5:305,0:0.1:8,sbin_itr',cmap="Reds",
    norm="segmented",
    levels=[0,1,10,20,50,90,100]
)
axs[7].format(title="Ocean")
axs[7].colorbar(c3,loc="r",label="Density")

for ax in axs
    ax.format(abc=true,grid="on")
end

f.savefig(plotsdir("erasurfacetemp.png"),transparent=false,dpi=200)
