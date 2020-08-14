using DrWatson
@quickactivate "DiConv"

using GeoRegions
using NCDatasets

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

ds = NCDataset(datadir("gpmimerg-prcp_rate-cmp-TRP.nc"))
elon = ds["longitude"][:]
elat = ds["latitude"][:]
eavg = ds["average"][:]*3600
edhr = ds["variability_diurnal"][:]*3600
eitr = ds["variability_intraseasonal"][:]*3600
close(ds)

tlon,tlat,rinfo = regiongridvec([20,-15,270,60],elon,elat)
ravg = regionextractgrid(eavg,rinfo)
rdhr = regionextractgrid(edhr,rinfo)
ritr = regionextractgrid(eitr,rinfo)

ods = NCDataset(datadir("ETOPO1.grd"))
olon = ods["x"][:]; olat = ods["y"][:]; oro = ods["z"][:]*1
oro[oro.>0] .= 1; oro[oro.<0] .= 0
rlon,rlat,rinfo = regiongridvec([20,-15,270,60],olon,olat)
roro = regionextractgrid(oro,rinfo); nlon = length(tlon); nlat = length(tlat);
glon = zeros(Int32,nlon); for i = 1 : nlon; glon[i] = argmin(abs.(tlon[i] .- rlon)) end
glat = zeros(Int32,nlat); for i = 1 : nlat; glat[i] = argmin(abs.(tlat[i] .- rlat)) end
rlsm = roro[glon,glat]
close(ods)

lavg = ravg[rlsm.>0.5]; ldhr = rdhr[rlsm.>0.5]; litr = ritr[rlsm.>0.5]
lbin_dhr = fit(Histogram,(lavg,ldhr),(0:0.005:0.6,0:0.05:6)).weights
lbin_dhr = lbin_dhr./sum(lbin_dhr)*14400; lbin_dhr[lbin_dhr.==0] .= NaN
lbin_itr = fit(Histogram,(lavg,litr),(0:0.005:0.6,0:0.05:6)).weights
lbin_itr = lbin_itr./sum(lbin_itr)*14400; lbin_itr[lbin_itr.==0] .= NaN

savg = ravg[rlsm.<0.5]; sdhr = rdhr[rlsm.<0.5]; sitr = ritr[rlsm.<0.5]
sbin_dhr = fit(Histogram,(savg,sdhr),(0:0.005:0.6,0:0.05:6)).weights
sbin_dhr = sbin_dhr./sum(sbin_dhr)*14400; sbin_dhr[sbin_dhr.==0] .= NaN
sbin_itr = fit(Histogram,(savg,sitr),(0:0.005:0.6,0:0.05:6)).weights
sbin_itr = sbin_itr./sum(sbin_itr)*14400; sbin_itr[sbin_itr.==0] .= NaN

coord = readdlm(srcdir("GLB-i.txt"),comments=true,comment_char='#')
x = coord[:,1]; y = coord[:,2];

pplt.close(); arr = [[1,1],[2,2],[3,3],[4,5],[4,5],[6,7],[6,7]];
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

c2 = axs[3].contourf(elon,elat,eitr',levels=0:0.5:5,cmap="drywet")
axs[3].plot(x,y,c="k",lw=0.2)
axs[3].plot([60,270,270,60,60],[-15,-15,20,20,-15],c="w",lw=1)
axs[3].format(ylim=(-30,30),rtitle="Intraseasonal Variability",xlim=(0,360),xlocator=[0:60:360])
axs[3].colorbar(c2,loc="r")

axs[4].pcolormesh(
    0:0.005:0.6,0:0.05:6,lbin_dhr',cmap="Blues",
    norm="segmented",
    levels=[0,1,10,20,50,90,100]
)
axs[4].plot([0,0.6],[0,6],c="k",lw=0.5)
axs[4].format(title="Land",ylabel="Diurnal Variability")

c3 = axs[5].pcolormesh(
    0:0.005:0.6,0:0.05:6,sbin_dhr',cmap="Blues",
    norm="segmented",
    levels=[0,1,10,20,50,90,100]
)
axs[5].plot([0,0.6],[0,6],c="k",lw=0.5)
axs[5].format(title="Ocean")
axs[5].colorbar(c3,loc="r",label="Density")

axs[6].pcolormesh(
    0:0.005:0.6,0:0.05:6,lbin_itr',cmap="Blues",
    norm="segmented",
    levels=[0,1,10,20,50,90,100]
)
axs[6].plot([0,0.6],[0,6],c="k",lw=0.5)
axs[6].format(title="Land",xlabel="Average",ylabel="Intraseasonal Variability")

c3 = axs[7].pcolormesh(
    0:0.005:0.6,0:0.05:6,sbin_itr',cmap="Blues",
    norm="segmented",
    levels=[0,1,10,20,50,90,100]
)
axs[7].plot([0,0.6],[0,6],c="k",lw=0.5)
axs[7].format(title="Ocean")
axs[7].colorbar(c3,loc="r",label="Density")

for ax in axs
    ax.format(abc=true,grid="on")
end

mkpath(plotsdir("OBS_CLIMATE"))
f.savefig(plotsdir("OBS_CLIMATE/gpmprcp.png"),transparent=false,dpi=200)
