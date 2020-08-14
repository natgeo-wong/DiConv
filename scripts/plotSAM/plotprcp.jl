using DrWatson
@quickactivate "DiConv"
using NCDatasets
using SAMTools
using Statistics

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

include(srcdir("diurnal.jl"));

prcpN1,t = getprcp(experiment="wtgN-diurnalY",config="dynamicSST-slab0.1")
prcpN2,_ = getprcp(experiment="wtgN-diurnalY",config="dynamicSST-slab0.2")
prcpN3,_ = getprcp(experiment="wtgN-diurnalY",config="dynamicSST-slab0.5")
prcpN4,_ = getprcp(experiment="wtgN-diurnalY",config="dynamicSST-slab01")
prcpN5,_ = getprcp(experiment="wtgN-diurnalY",config="fixedSST-temp303")

prcpY1,_ = getprcp(experiment="wtgY-diurnalY",config="dynamicSST-slab0.1")
prcpY2,_ = getprcp(experiment="wtgY-diurnalY",config="dynamicSST-slab0.2")
prcpY3,_ = getprcp(experiment="wtgY-diurnalY",config="dynamicSST-slab0.5")
prcpY4,_ = getprcp(experiment="wtgY-diurnalY",config="dynamicSST-slab01")
prcpY5,_ = getprcp(experiment="wtgY-diurnalY",config="fixedSST-temp305")

tvec = (1:t) ./ (t/24) .+ 12; tvec = collect(tvec);
tvec = mod.(vcat(tvec[48:end],tvec[1:48]),24); tvec[end] = 24

prcpN1 = vcat(prcpN1[48:end],prcpN1[1:48]) ./ 24
prcpN2 = vcat(prcpN2[48:end],prcpN2[1:48]) ./ 24
prcpN3 = vcat(prcpN3[48:end],prcpN3[1:48]) ./ 24
prcpN4 = vcat(prcpN4[48:end],prcpN4[1:48]) ./ 24
prcpN5 = vcat(prcpN5[48:end],prcpN5[1:48]) ./ 24

prcpY1 = vcat(prcpY1[48:end],prcpY1[1:48]) ./ 24
prcpY2 = vcat(prcpY2[48:end],prcpY2[1:48]) ./ 24
prcpY3 = vcat(prcpY3[48:end],prcpY3[1:48]) ./ 24
prcpY4 = vcat(prcpY4[48:end],prcpY4[1:48]) ./ 24
prcpY5 = vcat(prcpY5[48:end],prcpY5[1:48]) ./ 24

pplt.close(); f,axs = pplt.subplots(ncols=2,axwidth=4,aspect=2,sharey=1)

axs[1].plot(tvec,prcpN1,lw=1,label="0.1 m",legend="ul")
axs[1].plot(tvec,prcpN2,lw=1,label="0.2 m",legend="ul")
axs[1].plot(tvec,prcpN3,lw=1,label="0.5 m",legend="ul")
axs[1].plot(tvec,prcpN4,lw=1,label="1.0 m",legend="ul")
axs[1].plot(tvec,prcpN5,lw=1,label="Fixed",legend="ul",c="k")
axs[1].format(
    xlim=(0,24),xlocator=[0,3,6,9,12,15,18,21,24],ylim=(0,0.75),
    xlabel="Hour of Day",ylabel=L"Deviation from Mean / mm hr$^{-1}$",
    rtitle="WTG: False",abc=true,
    suptitle="Diurnal Variability of Precipitation against Slab Depth"
)

axs[2].plot(tvec,prcpY1,lw=1,label="0.1 m",legend="ul")
axs[2].plot(tvec,prcpY2,lw=1,label="0.2 m",legend="ul")
axs[2].plot(tvec,prcpY3,lw=1,label="0.5 m",legend="ul")
axs[2].plot(tvec,prcpY4,lw=1,label="1.0 m",legend="ul")
axs[2].plot(tvec,prcpY5,lw=1,label="Fixed",legend="ul",c="k")
axs[2].format(
    xlim=(0,24),xlocator=[0,3,6,9,12,15,18,21,24],ylim=(0,2.5),
    xlabel="Hour of Day",ylabel=L"Deviation from Mean / mm hr$^{-1}$",
    rtitle="WTG: True",abc=true,
    suptitle="Diurnal Variability of Precipitation against Slab Depth"
)

f.savefig(plotsdir("wtg-prcp.png"),transparent=false,dpi=200)
