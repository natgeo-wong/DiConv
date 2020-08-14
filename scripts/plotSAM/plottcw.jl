using DrWatson
@quickactivate "DiConv"
using NCDatasets
using SAMTools
using Statistics

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

include(srcdir("diurnal.jl"));

tcwN1,t = gettcw(experiment="wtgN-diurnalY",config="dynamicSST-slab0.1")
tcwN2,_ = gettcw(experiment="wtgN-diurnalY",config="dynamicSST-slab0.2")
tcwN3,_ = gettcw(experiment="wtgN-diurnalY",config="dynamicSST-slab0.5")
tcwN4,_ = gettcw(experiment="wtgN-diurnalY",config="dynamicSST-slab01")
tcwN5,_ = gettcw(experiment="wtgN-diurnalY",config="fixedSST-temp305")

tcwY1,_ = gettcw(experiment="wtgY-diurnalY",config="dynamicSST-slab0.1")
tcwY2,_ = gettcw(experiment="wtgY-diurnalY",config="dynamicSST-slab0.2")
tcwY3,_ = gettcw(experiment="wtgY-diurnalY",config="dynamicSST-slab0.5")
tcwY4,_ = gettcw(experiment="wtgY-diurnalY",config="dynamicSST-slab01")
tcwY5,_ = gettcw(experiment="wtgY-diurnalY",config="fixedSST-temp305")

tvec = (1:t) ./ (t/24) .+ 12; tvec = collect(tvec);
tvec = mod.(vcat(tvec[48:end],tvec[1:48]),24); tvec[end] = 24

tcwN1 = vcat(tcwN1[48:end],tcwN1[1:48]) .- mean(tcwN1)
tcwN2 = vcat(tcwN2[48:end],tcwN2[1:48]) .- mean(tcwN2)
tcwN3 = vcat(tcwN3[48:end],tcwN3[1:48]) .- mean(tcwN3)
tcwN4 = vcat(tcwN4[48:end],tcwN4[1:48]) .- mean(tcwN4)
tcwN5 = vcat(tcwN5[48:end],tcwN5[1:48]) .- mean(tcwN5)

tcwY1 = vcat(tcwY1[48:end],tcwY1[1:48]) .- mean(tcwY1)
tcwY2 = vcat(tcwY2[48:end],tcwY2[1:48]) .- mean(tcwY2)
tcwY3 = vcat(tcwY3[48:end],tcwY3[1:48]) .- mean(tcwY3)
tcwY4 = vcat(tcwY4[48:end],tcwY4[1:48]) .- mean(tcwY4)
tcwY5 = vcat(tcwY5[48:end],tcwY5[1:48]) .- mean(tcwY5)

pplt.close(); f,axs = pplt.subplots(ncols=2,axwidth=4,aspect=2,sharey=1)

axs[1].plot(tvec,tcwN1,lw=1,label="0.1 m",legend="ul")
axs[1].plot(tvec,tcwN2,lw=1,label="0.2 m",legend="ul")
axs[1].plot(tvec,tcwN3,lw=1,label="0.5 m",legend="ul")
axs[1].plot(tvec,tcwN4,lw=1,label="1.0 m",legend="ul")
axs[1].plot(tvec,tcwN5,lw=1,label="fixed",legend="ul",c="k")
axs[1].format(
    xlim=(0,24),xlocator=[0,3,6,9,12,15,18,21,24],ylim=(-0.5,0.5),
    xlabel="Hour of Day",ylabel=L"Deviation from Mean / mm hr$^{-1}$",
    rtitle="WTG: False",abc=true,
    suptitle="Diurnal Variability of Total Column Water against Slab Depth"
)

axs[2].plot(tvec,tcwY1,lw=1,label="0.1 m",legend="ul")
axs[2].plot(tvec,tcwY2,lw=1,label="0.2 m",legend="ul")
axs[2].plot(tvec,tcwY3,lw=1,label="0.5 m",legend="ul")
axs[2].plot(tvec,tcwY4,lw=1,label="1.0 m",legend="ul")
axs[2].plot(tvec,tcwY5,lw=1,label="fixed",legend="ul",c="k")
axs[2].format(
    xlim=(0,24),xlocator=[0,3,6,9,12,15,18,21,24],ylim=(-2.5,2.5),
    xlabel="Hour of Day",ylabel=L"Deviation from Mean / mm hr$^{-1}$",
    rtitle="WTG: True",abc=true,
    suptitle="Diurnal Variability of Total Column Water against Slab Depth"
)

f.savefig(plotsdir("SAM_PLOTS/tcw.png"),transparent=false,dpi=200)
