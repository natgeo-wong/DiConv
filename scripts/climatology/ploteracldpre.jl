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

init,eroot = erastartup(aID=2,dID=1)
rlsm,_,_ = eplotlsmgrid([10,-15,180,120],eroot["plot"],pID="GLB")
rlsm = rlsm[:,:,1]

ds = NCDataset(datadir("cld_tot.nc"))
lon = ds["longitude"][:]; nlon = length(lon)
lat = ds["latitude"][:];  nlat = length(lat)
tcc = zeros(nlon,nlat,24)
for ii = 1 : 24; @info ii
    tccii = ds["tcc"][:,:,ii:24:end]*1
    tcc[:,:,ii] = mean(tccii,dims=3)
end
close(ds)

tcc = tcc[(lon.<=180).&(lon.>=120),(lat.<=10).&(lat.>=-15),:]
tccp = zeros(24)
for ii = 1 : 24; tccpii = tcc[:,:,ii]; tccp[ii] = mean(tccpii[rlsm.<0.5]); end

pplt.close(); f,axs = pplt.subplots(nrows=1,aspect=4.5,axwidth=6,sharey=0)
axs[1].plot(0.5:23.5,tccp);
mkpath(plotsdir("OBS_CLIMATE"))
f.savefig(plotsdir("OBS_CLIMATE/eracld-hourly.png"),transparent=false,dpi=200)
