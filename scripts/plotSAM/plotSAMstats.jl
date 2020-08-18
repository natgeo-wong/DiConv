using DrWatson
@quickactivate "DiConv"
using NCDatasets
using SAMTools
using Statistics

include(srcdir("plots.jl"))
mkpath(plotsdir("SAM_STAT"))

plotteststats(isdiurnal=true,isdynamic=true,slab=0.1,iswtg=true)
plotteststats(isdiurnal=true,isdynamic=true,slab=0.2,iswtg=true)
plotteststats(isdiurnal=true,isdynamic=true,slab=0.5,iswtg=true)
plotteststats(isdiurnal=true,isdynamic=true,slab=1,iswtg=true)

plotteststats(isdiurnal=true,isdynamic=true,slab=0.1)
plotteststats(isdiurnal=true,isdynamic=true,slab=0.2)
plotteststats(isdiurnal=true,isdynamic=true,slab=0.5)
plotteststats(isdiurnal=true,isdynamic=true,slab=1)
