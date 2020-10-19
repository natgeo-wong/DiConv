using DrWatson
@quickactivate "DiConv"
using ClimateERA
using DelimitedFiles
using Dierckx
using NCDatasets
using SAMTools

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

ds = NCDataset(datadir("era5-w_air.nc"))
lon = ds["longitude"][:]
lat = ds["latitude"][:]
lvl = ds["level"][:]
w_air = ds["w_air"][:]
close(ds)

ds = NCDataset(datadir("era5-z_air.nc"))
z_air = ds["z"][:] ./ 9.81
close(ds)

coord = readdlm(srcdir("GLB-i.txt"),comments=true,comment_char='#')
x = coord[:,1]; y = coord[:,2];

pplt.close(); f,axs = pplt.subplots(aspect=4.5,axwidth=6,sharey=0);

c1 = axs[1].contourf(
    lon,lat,w_air[:,:,27]',
    levels=vcat(-10:2:-2,2:2:10)/100,
    cmap="RdBu_r",extend="both"
);
axs[1].plot(x,y,c="k",lw=0.2)
axs[1].plot([120,180,180,120,120],[-15,-15,10,10,-15],c="r",lw=1)
axs[1].format(xlim=(60,240),ylim=(-20,20))
axs[1].colorbar(c1,loc="r")

mkpath(plotsdir("OBS_CLIMATE"))
f.savefig(plotsdir("OBS_CLIMATE/eraw500hPa.png"),transparent=false,dpi=200)

w_air = w_air[(lon.<=180).&(lon.>=120),(lat.<=10).&(lat.>=-15),:]
z_air = z_air[(lon.<=180).&(lon.>=120),(lat.<=10).&(lat.>=-15),:]
init,eroot = erastartup(aID=2,dID=1)
rlsm,_,_ = eplotlsmgrid([10,-15,180,120],eroot["plot"],pID="GLB")
rlsm = rlsm[:,:,1]

nlvl = length(lvl); wavg = zeros(nlvl); zavg = zeros(nlvl);
for ilvl = 1 : nlvl
    w_airii = w_air[:,:,ilvl]; w_airii[rlsm.>0.5] .= NaN
    nanii = .!isnan.(w_airii)
    wavg[ilvl] = mean(w_airii[nanii])
    z_airii = z_air[:,:,ilvl]; z_airii[rlsm.>0.5] .= NaN
    zavg[ilvl] = mean(z_airii[nanii])
end

pplt.close(); f,axs = pplt.subplots(aspect=0.5,axwidth=2);
axs[1].plot(wavg,lvl);
axs[1].format(ylim=(1000,0))
mkpath(plotsdir("OBS_CLIMATE"))
f.savefig(plotsdir("OBS_CLIMATE/erawprofile.png"),transparent=false,dpi=200)

pplt.close(); f,axs = pplt.subplots(aspect=0.5,axwidth=2);
axs[1].plot(zavg,lvl);
axs[1].format(ylim=(1000,0))
mkpath(plotsdir("OBS_CLIMATE"))
f.savefig(plotsdir("OBS_CLIMATE/erazprofile.png"),transparent=false,dpi=200)

splzp = Spline1D(lvl*100,zavg); dzdp = derivative(splzp,lvl*100;nu=1)
wz = wavg .* dzdp
pplt.close(); f,axs = pplt.subplots(aspect=0.5,axwidth=2);
axs[1].plot(wz,lvl);
axs[1].format(ylim=(1000,0),ylabel="Pressure / hPa",xlabel=L"w / m s$^{-1}$")
mkpath(plotsdir("OBS_CLIMATE"))
f.savefig(plotsdir("OBS_CLIMATE/erawprofile2.png"),transparent=false,dpi=200)


lsf = lsfinit(); lsf[:,7] .= reverse(wz)
lsfprint(projectdir("exp/lsf/warmpool"),lsf,1005.50)
