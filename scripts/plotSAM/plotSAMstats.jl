using DrWatson
@quickactivate "DiConv"

include(srcdir("plotstats.jl"))

plotstatistics("DiurnalAmp","SlabInf",plotSST=true)
plotstatistics("DiurnalAmp","Slab20.0",plotSST=true)
plotstatistics("DiurnalAmp","Slab10.0",plotSST=true)
plotstatistics("DiurnalAmp","Slab05.0",plotSST=true)
plotstatistics("DiurnalAmp","Slab02.0",plotSST=true)
plotstatistics("DiurnalAmp","Slab01.0",plotSST=true)
plotstatistics("DiurnalAmp","Slab00.5",plotSST=true)
plotstatistics("DiurnalAmp","Slab00.2",plotSST=true)
plotstatistics("DiurnalAmp","Slab00.1",plotSST=true)
