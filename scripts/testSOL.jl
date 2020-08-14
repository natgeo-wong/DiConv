using DrWatson
@quickactivate "DiConv"
using NCDatasets
using SAMTools
using Statistics

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

include(srcdir("diurnal.jl"));

insN,t = getsol(experiment="wtgN-diurnalY",config="dynamicSST-slab01")
insY,t = getsol(experiment="wtgY-diurnalY",config="dynamicSST-slab01")

tvec = (1:t) ./ (t/24) .+ 12; tvec = collect(tvec);
tvec = mod.(vcat(tvec[48:end],tvec[1:48]),24); tvec[end] = 24

insN = vcat(insN[48:end],insN[1:48])
insY = vcat(insY[48:end],insY[1:48])

pplt.close(); f,axs = pplt.subplots(axwidth=4,aspect=2,sharey=1)

axs[1].plot(tvec,insN,lw=1,label="Latitude 45",legend="ul")
axs[1].plot(tvec,insY,lw=1,label="Latitude 0",legend="ul")
axs[1].format(
    xlim=(0,24),xlocator=[0,3,6,9,12,15,18,21,24],
    xlabel="Hour of Day",ylabel=L"Insolation / W m$^{-2}$",
)

f.savefig(plotsdir("SAM_PLOTS/insolation.png"),transparent=false,dpi=200)
