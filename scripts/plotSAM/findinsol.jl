using DrWatson
@quickactivate "DiConv"

using DataFrames
using GLM

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

function extracteb(insol::Real)

    dfol = datadir("FindInsolRCE/Insol$(insol)/ANA/")
    dfnc = joinpath(dfol,"sfcflux.nc")

    rce = NCDataset(dfnc); t = rce["t"][:];
    eb = rce["ebal_sfc"][:];
    sw = rce["sw_net_sfc"][:];
    lw = rce["lw_net_sfc"][:];
    sh = rce["hflux_s"][:];
    lh = rce["hflux_l"][:];
    close(rce)

    tstep = round(Integer,(length(t) - 1) / (t[end] - t[1]))

    eb = mean(reshape(eb,tstep,:)[:,101:200]);
    sw = mean(reshape(sw,tstep,:)[:,101:200]);
    lw = mean(reshape(lw,tstep,:)[:,101:200]);
    sh = mean(reshape(sh,tstep,:)[:,101:200]);
    lh = mean(reshape(lh,tstep,:)[:,101:200]);

    return eb,sw,lw,sh,lh

end

insol = [880.0,890.0,900.0,910.0,920.0,930.0,940.0]; ninsol = length(insol)

eb = zeros(ninsol); sw = zeros(ninsol); lw = zeros(ninsol)
sh = zeros(ninsol); lh = zeros(ninsol)

for ii = 1 : ninsol
    eb[ii],sw[ii],lw[ii],sh[ii],lh[ii] = extracteb(insol[ii])
end

eb1,sw1,lw1,sh1,lh1 = extracteb(916.6)

data = DataFrame(Insolation=insol,Balance=eb,Shortwave=sw,Longwave=lw,Sensible=sh,Latent=lh)
ols = lm(@formula(Balance ~ Insolation), data)
c = coef(ols); fz = - c[1] / c[2];
x = [880,940]; y = c[1] .+ c[2] * x

pplt.close(); arr = [[0,1,1,0],[2,2,3,3],[4,4,5,5]]
f,axs = pplt.subplots(arr,axwidth=4,aspect=2,sharey=1)

axs[1].plot(x,y,c="k",linestyle="--",lw=1)
axs[1].scatter(insol,eb); axs[1].scatter(916.6,eb1); axs[1].scatter(fz,0,c="k",marker="x");
axs[1].text(fz+1,-1,"($(@sprintf("%5.2f",fz)),0)")
axs[2].scatter(insol,sw); axs[2].scatter(916.6,sw1)
axs[3].scatter(insol,lw); axs[3].scatter(916.6,lw1)
axs[4].scatter(insol,sh); axs[4].scatter(916.6,sh1)
axs[5].scatter(insol,lh); axs[5].scatter(916.6,lh1)

axs[1].format(title="Surface Energy Balance",ylabel=L"W m$^{-2}$")
axs[2].format(title="Net Shortwave")
axs[3].format(title="Net Longwave")
axs[4].format(title="Sensible Heat")
axs[5].format(title="Latent Heat",xlabel=L"Insolation / W m$^{-2}$",ylabel=L"W m$^{-2}$")

f.savefig(plotsdir("findinsol.png"),transparent=false,dpi=200)
