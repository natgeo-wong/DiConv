using DrWatson
@quickactivate "DiConv"
using NCDatasets
using Statistics

include(srcdir("plots.jl"))
mkpath(plotsdir("SAM_STAT"))

plotstatsdiurnal("RCEProfile","InsolRCE")
plotstatsdiurnal("RCEProfile","InsolTRP")

plotstatsdiurnal("DiurnalAmp","SlabInf",plotSST=true)
plotstatsdiurnal("DiurnalAmp","Slab10.0",plotSST=true)
plotstatsdiurnal("DiurnalAmp","Slab05.0",plotSST=true)
plotstatsdiurnal("DiurnalAmp","Slab02.0",plotSST=true)
plotstatsdiurnal("DiurnalAmp","Slab01.0",plotSST=true)
plotstatsdiurnal("DiurnalAmp","Slab00.5",plotSST=true)
plotstatsdiurnal("DiurnalAmp","Slab00.2",plotSST=true)
plotstatsdiurnal("DiurnalAmp","Slab00.1",plotSST=true)
