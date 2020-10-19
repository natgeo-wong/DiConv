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

pplt.close(); f,axs = pplt.subplots(nrows=1,aspect=4.5,axwidth=6,sharey=0)

ds = NCDataset(datadir("cld_tot-2.nc"))
lon = ds["longitude"][:]
lat = ds["latitude"][:]
tcc = ds["tcc"][:]
close(ds)

c = axs[1].contourf(
    lon,lat,dropdims(mean(tcc,dims=3),dims=3)',cmap="Blues",levels=0:0.1:1
);
axs[1].plot(x,y,c="k",lw=0.2)
axs[1].plot([120,180,180,120,120],[-15,-15,10,10,-15],c="r",lw=1)
axs[1].format(xlim=(60,240),ylim=(-20,20),rtitle="Cloud Cover")

mkpath(plotsdir("OBS_CLIMATE"))
axs[1].colorbar(c,loc="r")

f.savefig(plotsdir("OBS_CLIMATE/eracld.png"),transparent=false,dpi=200)
