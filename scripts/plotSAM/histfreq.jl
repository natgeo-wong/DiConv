using DrWatson
@quickactivate "DiConv"

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

include(srcdir("histbin.jl"))

function plothistbin(
    experiment::AbstractString,config::AbstractString,
    axs::AbstractArray{<:PyObject};
    avg2D::Bool=true
)

    edges,w,mprcp = prcp2hist(experiment,config,avg2D=avg2D)
    x = (collect(edges[2:end]).+collect(edges[1:(end-1)]))/2
    w = w / sum(w) * length(x)
    axs[1].plot(x,w,lw=1)

    if avg2D
          axs[1].format(xlim=(0,10),ylim=(0.01,100),yscale="log")
    else; axs[1].format(xlim=(0.01,1000),yscale="log",xscale="log")
    end

    edges,w,mcsf  = csf2hist(experiment,config,avg2D=avg2D)
    x = (collect(edges[2:end]).+collect(edges[1:(end-1)]))/2
    w = w / sum(w) * length(x)
    axs[2].plot(x,w,lw=1)
    axs[2].format(xlim=(0.6,1))

end

pplt.close(); f,axs = pplt.subplots(nrows=2,axwidth=4,aspect=2,sharex=1)

plothistbin("DiurnalAmp","SlabInf",axs,avg2D=false)
plothistbin("DiurnalAmp","Slab20.0",axs,avg2D=false)
plothistbin("DiurnalAmp","Slab05.0",axs,avg2D=false)
plothistbin("DiurnalAmp","Slab01.0",axs,avg2D=false)
plothistbin("DiurnalAmp","Slab00.2",axs,avg2D=false)

f.savefig(plotsdir("SAM_PLOTS/distribution.png"),transparent=false,dpi=200)
