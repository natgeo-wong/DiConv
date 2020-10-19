using DrWatson
@quickactivate "DiConv"
using ClimateERA
using NCDatasets

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

init,eroot = erastartup(aID=2,dID=1)
rlsm,_,_ = eplotlsmgrid([10,-15,180,120],eroot["plot"],pID="GLB")
rlsm = rlsm[:,:,1]

lvl = [
    50,70,100,125,150,175,200,225,250,
    300,350,400,450,500,550,600,650,700,750,
    775,800,825,850,875,900,925,950,975,1000
]; nlvl = length(lvl)

yr = 1979 : 2019; nyr = length(yr)

ds = NCDataset(datadir("cld-50hPa-1979.nc"))
lon = ds["longitude"][:]; nlon = length(lon)
lat = ds["latitude"][:];  nlat = length(lat)
close(ds)
tcc = zeros(nlon,nlat,24,nlvl)

for ilvl = 1 : nlvl, iyr = 1 : nyr

    ds = NCDataset(datadir("cld-$(lvl[ilvl])hPa-$(yr[iyr]).nc"))
    lon = ds["longitude"][:]; nlon = length(lon)
    lat = ds["latitude"][:];  nlat = length(lat)
    tcc[:,:,:,ii] += dropdims(mean(reshape(ds["cld"][:]*1,nlon,nlat,24,:),dims=4),dims=4)
    close(ds)

end

tcc = tcc ./ nyr
tcc = tcc[(lon.<=180).&(lon.>=120),(lat.<=10).&(lat.>=-15),:,:]
tccp = zeros(24,nlvl)
for ilvl = 1 : nlvl, ihr = 1 : 24
    tccpii = tcc[:,:,ihr,ilvl];
    tccp[ihr,ilvl] = mean(tccpii[rlsm.<0.5])
end

pplt.close(); f,axs = pplt.subplots(nrows=1,aspect=2,axwidth=6,sharey=0)
axs[1].contourf(0.5:23.5,lvl,tccp');
axs[1].format(xlim=(0,24),xlabel="Hour of Day",ylabel="Pressure / hPa");
mkpath(plotsdir("OBS_CLIMATE"))
f.savefig(plotsdir("OBS_CLIMATE/eracld-pre.png"),transparent=false,dpi=200)
