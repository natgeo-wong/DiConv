using DrWatson
@quickactivate "DiConv"

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

include(srcdir("histbin.jl"))

function plothistbin(
    experiment::AbstractString,config::AbstractString,
    axs::AbstractArray{<:PyObject}
)

    edges,w,mprcp = prcp2hist(experiment,config)
    x = (collect(edges[2:end]).+collect(edges[1:(end-1)]))/2
    w = w ./ sum(w)
    axs[1].plot(x,w,lw=1)
    axs[1].format(xlim=(minimum(x),maximum(x)),ylim=(0,1))

    edges,w,mcsf  = csf2hist(experiment,config)
    x = (collect(edges[2:end]).+collect(edges[1:(end-1)]))/2
    w = w ./ sum(w)
    axs[2].plot(x,w,lw=1)
    axs[2].format(xlim=(minimum(x),maximum(x)),ylim=(0,1))

end

pplt.close(); f,axs = pplt.subplots(ncols=2,axwidth=4,aspect=2)

plothistbin("DiurnalAmp","SlabInf",axs)

f.savefig(plotsdir("SAM_PLOTS/distribution.png"),transparent=false,dpi=200)
