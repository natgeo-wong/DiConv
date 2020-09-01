using DrWatson
@quickactivate "DiConv"

include(srcdir("plotstats.jl"))

plotspinup("DiurnalAmp","SlabInf",plotSST=true)
plotspinup("DiurnalAmp","Slab20.0",plotSST=true)
plotspinup("DiurnalAmp","Slab10.0",plotSST=true)
plotspinup("DiurnalAmp","Slab05.0",plotSST=true)
plotspinup("DiurnalAmp","Slab02.0",plotSST=true)
plotspinup("DiurnalAmp","Slab01.0",plotSST=true)
plotspinup("DiurnalAmp","Slab00.5",plotSST=true)
plotspinup("DiurnalAmp","Slab00.2",plotSST=true)
plotspinup("DiurnalAmp","Slab00.1",plotSST=true)
