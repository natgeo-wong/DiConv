using DrWatson
@quickactivate "DiConv"
using NCDatasets
using SAMTools
using Statistics

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

include(srcdir("diurnal.jl"));

function plot3Ddiurnal(
    experiment::AbstractString, config::AbstractString;
    modID::AbstractString, parID::AbstractString
)

    var,z,t = getdiurnal3D(experiment,config,modID=modID,parID=parID)
    tvec = (1:t) ./ (t/24) .+ 12; tvec = collect(tvec);
    tvec = mod.(vcat(tvec[12:end],tvec[1:12]),24); tvec[end] = 24
    mvar = mean(var,dims=2); var = cat(dims=2,var[:,12:end],var[:,1:12]) .- mvar

    pplt.close(); arr = [1,2,2,2]; f,axs = pplt.subplots(arr,axwidth=0.5,aspect=2)

    axs[1].plot(z,mvar,lw=1)
    axs[1].format(
        xlabel="Daily Mean / K",
        yscale="log",ylabel="Height / km",
        suptitle="Diurnal Cycle of Air Temperature"
    )

    axs[2].contourf(tvec,z,var)
    axs[2].format(
        xlim=(0,24),xlocator=[0,3,6,9,12,15,18,21,24],xlabel="Hour of Day",
    )

    f.savefig(plotsdir("SAM_PLOTS/$pID-$exp-$config.png"),transparent=false,dpi=200)

end

plot3Ddiurnal("DiurnalAmp","SlabInf",modID="s3D",parID="t_abs")
