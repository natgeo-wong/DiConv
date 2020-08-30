using DrWatson
@quickactivate "DiConv"
using NCDatasets
using SAMTools
using Statistics

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

include(srcdir("diurnal.jl"));

cont1,t = getsst("DiurnalAmp","Slab20.0")
cont2,_ = getsst("DiurnalAmp","Slab10.0")
cont3,_ = getsst("DiurnalAmp","Slab05.0")
cont4,_ = getsst("DiurnalAmp","Slab02.0")
cont5,_ = getsst("DiurnalAmp","Slab01.0")
cont6,_ = getsst("DiurnalAmp","Slab00.5")
cont7,_ = getsst("DiurnalAmp","Slab00.2")
cont8,_ = getsst("DiurnalAmp","Slab00.1")

tvec = (1:t) ./ (t/24) .+ 12; tvec = collect(tvec);
tvec = mod.(vcat(tvec[48:end],tvec[1:48]),24); tvec[end] = 24

cont1 = vcat(cont1[48:end],cont1[1:48]) .- mean(cont1)
cont2 = vcat(cont2[48:end],cont2[1:48]) .- mean(cont2)
cont3 = vcat(cont3[48:end],cont3[1:48]) .- mean(cont3)
cont4 = vcat(cont4[48:end],cont4[1:48]) .- mean(cont4)
cont5 = vcat(cont5[48:end],cont5[1:48]) .- mean(cont5)
cont6 = vcat(cont6[48:end],cont6[1:48]) .- mean(cont6)
cont7 = vcat(cont7[48:end],cont7[1:48]) .- mean(cont7)
cont8 = vcat(cont8[48:end],cont8[1:48]) .- mean(cont8)

pplt.close(); f,axs = pplt.subplots(ncols=1,axwidth=4,aspect=2)

axs[1].plot(tvec,cont1,lw=1,label="20.0",legend="ul")
axs[1].plot(tvec,cont2,lw=1,label="10.0",legend="ul")
axs[1].plot(tvec,cont3,lw=1,label="05.0",legend="ul")
axs[1].plot(tvec,cont4,lw=1,label="02.0",legend="ul")
axs[1].plot(tvec,cont5,lw=1,label="01.0",legend="ul")
axs[1].plot(tvec,cont6,lw=1,label="00.5",legend="ul")
axs[1].plot(tvec,cont7,lw=1,label="00.2",legend="ul")
axs[1].plot(tvec,cont8,lw=1,label="00.1",legend="ul")

axs[1].format(
    xlim=(0,24),xlocator=[0,3,6,9,12,15,18,21,24],#ylim=(295,315),
    xlabel="Hour of Day",ylabel="Deviation from Mean / K",
    suptitle="Diurnal Cycle of SST against Slab Depth (m)"
)

f.savefig(plotsdir("SAM_PLOTS/sst.png"),transparent=false,dpi=200)
