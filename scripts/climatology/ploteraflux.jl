using DrWatson
@quickactivate "DiConv"
using ClimateERA
using Crayons.Box
using DelimitedFiles
using Logging
using NCDatasets

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

coord = readdlm(srcdir("GLB-i.txt"),comments=true,comment_char='#')
x = coord[:,1]; y = coord[:,2];

pplt.close(); f,axs = pplt.subplots(nrows=5,aspect=4.5,axwidth=6,sharey=0);
lvl = [-25,-20,-15,-10,-5,-4,-3,-2,-1,1,2,3,4,5,10,15,20,25]*10

ds = NCDataset(datadir("sw_net_sfc.nc"))
lon = ds["longitude"][:]
lat = ds["latitude"][:]
sw  = ds["ssr"][:,:,1,1:(41*12)] / (30*3600)
close(ds)

axs[1].contourf(
    lon,lat,dropdims(mean(sw,dims=3),dims=3)',
    levels=lvl,cmap="RdBu_r",extend="both"
);
axs[1].plot(x,y,c="k",lw=0.2)
axs[1].plot([120,180,180,120,120],[-15,-15,10,10,-15],c="r",lw=1)
axs[1].format(xlim=(60,240),ylim=(-20,20),rtitle="Shortwave Flux")

ds = NCDataset(datadir("lw_net_sfc.nc"))
lon = ds["longitude"][:]
lat = ds["latitude"][:]
lw = ds["str"][:,:,1,1:(41*12)] / (30*3600)
close(ds)

axs[2].contourf(
    lon,lat,dropdims(mean(lw,dims=3),dims=3)',
    levels=lvl,cmap="RdBu_r",extend="both"
);
axs[2].plot(x,y,c="k",lw=0.2)
axs[2].plot([120,180,180,120,120],[-15,-15,10,10,-15],c="r",lw=1)
axs[2].format(xlim=(60,240),ylim=(-20,20),rtitle="Longwave Flux")

ds = NCDataset(datadir("shf_sfc.nc"))
lon = ds["longitude"][:]
lat = ds["latitude"][:]
shf = ds["sshf"][:,:,1,1:(41*12)] / (30*3600)
close(ds)

axs[3].contourf(
    lon,lat,dropdims(mean(shf,dims=3),dims=3)',
    levels=lvl,cmap="RdBu_r",extend="both"
);
axs[3].plot(x,y,c="k",lw=0.2)
axs[3].plot([120,180,180,120,120],[-15,-15,10,10,-15],c="r",lw=1)
axs[3].format(xlim=(60,240),ylim=(-20,20),rtitle="Sensible Heat Flux")

ds = NCDataset(datadir("lhf_sfc.nc"))
lon = ds["longitude"][:]
lat = ds["latitude"][:]
lhf = ds["slhf"][:,:,1,1:(41*12)] / (30*3600)
close(ds)

c = axs[4].contourf(
    lon,lat,dropdims(mean(lhf,dims=3),dims=3)',
    levels=lvl,cmap="RdBu_r",extend="both"
);
axs[4].plot(x,y,c="k",lw=0.2)
axs[4].plot([120,180,180,120,120],[-15,-15,10,10,-15],c="r",lw=1)
axs[4].format(xlim=(60,240),ylim=(-20,20),rtitle="Latent Heat Flux")

eb = lhf .+ shf .+ sw .+ lw
axs[5].contourf(
    lon,lat,dropdims(mean(eb,dims=3),dims=3)',
    levels=lvl,cmap="RdBu_r",extend="both"
);
axs[5].plot(x,y,c="k",lw=0.2)
axs[5].plot([120,180,180,120,120],[-15,-15,10,10,-15],c="r",lw=1)
axs[5].format(xlim=(60,240),ylim=(-20,20),rtitle="Surface Energy Balance")

mkpath(plotsdir("OBS_CLIMATE"))
axs[1].colorbar(c,loc="r")
axs[2].colorbar(c,loc="r")
axs[3].colorbar(c,loc="r")
axs[4].colorbar(c,loc="r")
axs[5].colorbar(c,loc="r")

f.savefig(plotsdir("OBS_CLIMATE/erasfcflux.png"),transparent=false,dpi=200)

init,eroot = erastartup(aID=2,dID=1)
rlsm,_,_ = eplotlsmgrid([10,-15,180,120],eroot["plot"],pID="GLB")
rlsm = rlsm[:,:,1]

lhf_sfc = mean(lhf[(lon.<=180).&(lon.>=120),(lat.<=10).&(lat.>=-15),:],dims=3)
shf_sfc = mean(shf[(lon.<=180).&(lon.>=120),(lat.<=10).&(lat.>=-15),:],dims=3)
sw_sfc  = mean(sw[(lon.<=180).&(lon.>=120),(lat.<=10).&(lat.>=-15),:],dims=3)
lw_sfc  = mean(lw[(lon.<=180).&(lon.>=120),(lat.<=10).&(lat.>=-15),:],dims=3)
eb_sfc  = mean(eb[(lon.<=180).&(lon.>=120),(lat.<=10).&(lat.>=-15),:],dims=3)

lhf_sfc = mean(dropdims(lhf_sfc,dims=3)[rlsm.<0.5])
shf_sfc = mean(dropdims(shf_sfc,dims=3)[rlsm.<0.5])
sw_sfc  = mean(dropdims(sw_sfc,dims=3)[rlsm.<0.5])
lw_sfc  = mean(dropdims(lw_sfc,dims=3)[rlsm.<0.5])
eb_sfc  = mean(dropdims(eb_sfc,dims=3)[rlsm.<0.5])

@info """The following are the summarized statistics for the energy surface:
  $(BOLD("Overall Balance:"))    $eb_sfc
  $(BOLD("Shortwave Flux:"))     $sw_sfc
  $(BOLD("Longwave Flux:"))      $lw_sfc
  $(BOLD("Sensible Heat Flux:")) $shf_sfc
  $(BOLD("Latent Heat Flux:"))   $lhf_sfc
"""
