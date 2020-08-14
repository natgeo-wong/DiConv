using DrWatson
@quickactivate "DiConv"
using NCDatasets
using SAMTools
using Statistics

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

include(srcdir("diurnal.jl"));

# sstN1,t = getsst(experiment="wtgN-diurnalY",config="dynamicSST-slab0.1")
# sstN2,_ = getsst(experiment="wtgN-diurnalY",config="dynamicSST-slab0.2")
# sstN3,_ = getsst(experiment="wtgN-diurnalY",config="dynamicSST-slab0.5")
# sstN4,_ = getsst(experiment="wtgN-diurnalY",config="dynamicSST-slab01")
#
# sstY1,_ = getsst(experiment="wtgY-diurnalY",config="dynamicSST-slab0.1")
# sstY2,_ = getsst(experiment="wtgY-diurnalY",config="dynamicSST-slab0.2")
# sstY3,_ = getsst(experiment="wtgY-diurnalY",config="dynamicSST-slab0.5")
# sstY4,_ = getsst(experiment="wtgY-diurnalY",config="dynamicSST-slab01")
#
# tvec = (1:t) ./ (t/24) .+ 12; tvec = collect(tvec);
# tvec = mod.(vcat(tvec[48:end],tvec[1:48]),24); tvec[end] = 24
#
# sstN1 = vcat(sstN1[48:end],sstN1[1:48]) .- mean(sstN1)
# sstN2 = vcat(sstN2[48:end],sstN2[1:48]) .- mean(sstN2)
# sstN3 = vcat(sstN3[48:end],sstN3[1:48]) .- mean(sstN3)
# sstN4 = vcat(sstN4[48:end],sstN4[1:48]) .- mean(sstN4)
#
# sstY1 = vcat(sstY1[48:end],sstY1[1:48]) .- mean(sstY1)
# sstY2 = vcat(sstY2[48:end],sstY2[1:48]) .- mean(sstY2)
# sstY3 = vcat(sstY3[48:end],sstY3[1:48]) .- mean(sstY3)
# sstY4 = vcat(sstY4[48:end],sstY4[1:48]) .- mean(sstY4)

pplt.close(); f,axs = pplt.subplots(ncols=2,axwidth=4,aspect=2)

axs[1].plot(tvec,sstN1,lw=1,label="0.1 m",legend="ul")
axs[1].plot(tvec,sstN2,lw=1,label="0.2 m",legend="ul")
axs[1].plot(tvec,sstN3,lw=1,label="0.5 m",legend="ul")
axs[1].plot(tvec,sstN4,lw=1,label="1.0 m",legend="ul")
axs[1].format(
    xlim=(0,24),xlocator=[0,3,6,9,12,15,18,21,24],ylim=(295,315),
    xlabel="Hour of Day",ylabel="Deviation from Mean / K",
    rtitle="WTG: False",abc=true,
    suptitle="Diurnal Variability of SST against Slab Depth"
)

axs[2].plot(tvec,sstY1,lw=1,label="0.1 m",legend="ul")
axs[2].plot(tvec,sstY2,lw=1,label="0.2 m",legend="ul")
axs[2].plot(tvec,sstY3,lw=1,label="0.5 m",legend="ul")
axs[2].plot(tvec,sstY4,lw=1,label="1.0 m",legend="ul")
axs[2].format(
    xlim=(0,24),xlocator=[0,3,6,9,12,15,18,21,24],ylim=(-10,15),
    xlabel="Hour of Day",ylabel="Deviation from Mean / K",
    rtitle="WTG: True",abc=true,
    suptitle="Diurnal Variability of SST against Slab Depth"
)

f.savefig(plotsdir("wtg-sst.png"),transparent=false,dpi=200)
