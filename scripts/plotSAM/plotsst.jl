using DrWatson
@quickactivate "DiConv"
using NCDatasets
using SAMTools
using Statistics

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

include(srcdir("diurnal.jl"));

cont0,t = getsst(experiment="control_tests",config="insol900.0")
cont1,_ = getsst(experiment="control_tests",config="insol910.0")
cont2,_ = getsst(experiment="control_tests",config="insol920.0")
cont3,_ = getsst(experiment="control_tests",config="insol930.0")
cont4,_ = getsst(experiment="control_tests",config="insol940.0")
cont5,_ = getsst(experiment="control_tests",config="insol950.0")
cont6,_ = getsst(experiment="control_tests",config="insol960.0")
cont7,_ = getsst(experiment="control_tests",config="insol970.0")
cont8,_ = getsst(experiment="control_tests",config="insol980.0")

tvec = (1:t) ./ (t/24) .+ 12; tvec = collect(tvec);
tvec = mod.(vcat(tvec[48:end],tvec[1:48]),24); tvec[end] = 24

cont0 = vcat(cont0[48:end],cont0[1:48]) .- mean(cont0)
cont1 = vcat(cont1[48:end],cont1[1:48]) .- mean(cont1)
cont2 = vcat(cont2[48:end],cont2[1:48]) .- mean(cont2)
cont3 = vcat(cont3[48:end],cont3[1:48]) .- mean(cont3)
cont4 = vcat(cont4[48:end],cont4[1:48]) .- mean(cont4)
cont5 = vcat(cont5[48:end],cont5[1:48]) .- mean(cont5)
cont6 = vcat(cont6[48:end],cont6[1:48]) .- mean(cont6)
cont7 = vcat(cont7[48:end],cont7[1:48]) .- mean(cont7)
cont8 = vcat(cont8[48:end],cont8[1:48]) .- mean(cont8)

pplt.close(); f,axs = pplt.subplots(ncols=1,axwidth=4,aspect=2)

# axs[1].plot(tvec,cont0,lw=1); axs[1].plot(tvec,cont1,lw=1); axs[1].plot(tvec,cont2,lw=1)
axs[1].plot(tvec,cont3,lw=1); axs[1].plot(tvec,cont4,lw=1); axs[1].plot(tvec,cont5,lw=1)
# axs[1].plot(tvec,cont6,lw=1); axs[1].plot(tvec,cont7,lw=1); axs[1].plot(tvec,cont8,lw=1)
axs[1].format(
    xlim=(0,24),xlocator=[0,3,6,9,12,15,18,21,24],#ylim=(295,315),
    xlabel="Hour of Day",ylabel="Deviation from Mean / K",
    rtitle="WTG: False",abc=true,
    suptitle="Diurnal Variability of SST against Slab Depth"
)

f.savefig(plotsdir("SAM_PLOTS/sst.png"),transparent=false,dpi=200)