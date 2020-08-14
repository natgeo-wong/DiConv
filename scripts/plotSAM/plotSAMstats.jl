using DrWatson
@quickactivate "DiConv"
using NCDatasets
using SAMTools
using Statistics

include(srcdir("plots.jl"))
mkpath(plotsdir("statplots"))

plotstatsummary(isdiurnal=true,isdynamic=true,slab=0.1,iswtg=true)
plotstatsummary(isdiurnal=true,isdynamic=true,slab=0.2,iswtg=true)
plotstatsummary(isdiurnal=true,isdynamic=true,slab=0.5,iswtg=true)
plotstatsummary(isdiurnal=true,isdynamic=true,slab=1,iswtg=true)

plotstatsummary(isdiurnal=true,isdynamic=true,slab=0.1)
plotstatsummary(isdiurnal=true,isdynamic=true,slab=0.2)
plotstatsummary(isdiurnal=true,isdynamic=true,slab=0.5)
plotstatsummary(isdiurnal=true,isdynamic=true,slab=1)
