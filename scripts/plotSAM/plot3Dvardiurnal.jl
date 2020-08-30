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
    tvec = mod.(cat(dims=2,tvec[12:end],tvec[1:12]),24); tvec[end] = 24
    mvar = mean(var,dims=2); var = cat(dims=2,var[:,48:end],var[:,1:48]) .- var

    pplt.close(); arr = [1,2,2,2]; f,axs = pplt.subplots(ncols=1,axwidth=0.5,aspect=2)

    axs[1].plot(z,var,lw=1)

    axs[1].format(
        xlim=(0,24),xlocator=[0,3,6,9,12,15,18,21,24],xlabel="Hour of Day",
        yscale="log",ylabel="Deviation from Mean / mm",
        suptitle="Diurnal Cycle of Column Water against Slab Depth (m)"
    )

    f.savefig(plotsdir("SAM_PLOTS/$pID-$exp-$config.png"),transparent=false,dpi=200)

end

plot3Ddiurnal("DiurnalAmp","SlabInf",modID="s3D",parID="t_abs")
