using DrWatson
@quickactivate "DiConv"
using NCDatasets
using Statistics

include(srcdir("plots.jl"))
mkpath(plotsdir("SAM_STAT"))

# plotstatsoverview("DiurnalIs","diurnalN-dynamicN-wtgN")
# plotstatsoverview("DiurnalIs","diurnalY-dynamicN-wtgN")
# plotstatsoverview("DiurnalIs","diurnalN-dynamicN-wtgY",plotWTG=true)
# plotstatsoverview("DiurnalIs","diurnalY-dynamicN-wtgY",plotWTG=true)
# plotstatsoverview("DiurnalIs","diurnalN-dynamicY-wtgN",plotSST=true)
# plotstatsoverview("DiurnalIs","diurnalY-dynamicY-wtgN",plotSST=true)
#
# plotstatsoverview("RCEProfile","InsolRCE")
# plotstatsoverview("RCEProfile","InsolTRP")
#
# plotstatsoverview("TestWTG","dynamicN-insolRCE-sndRCE",plotWTG=true)
# plotstatsoverview("TestWTG","dynamicN-insolTRP-sndRCE",plotWTG=true)
# plotstatsoverview("TestWTG","dynamicN-insolTRP-sndTRP",plotWTG=true)
# plotstatsoverview("TestWTG","dynamicY-insolRCE-sndRCE",plotWTG=true)
# plotstatsoverview("TestWTG","dynamicY-insolTRP-sndRCE",plotWTG=true)
# plotstatsoverview("TestWTG","dynamicY-insolTRP-sndTRP",plotWTG=true)
#
# plotstatsoverview("TestWTG","diurnalN-insolRCE-sndRCE",plotWTG=true)
# plotstatsoverview("TestWTG","diurnalN-insolTRP-sndTRP",plotWTG=true)
#
# plotstatsdiurnal("RCEProfile","InsolRCE")
# plotstatsdiurnal("RCEProfile","InsolTRP")
#
# plotstatsdiurnal("TestWTG","dynamicN-insolRCE-sndRCE",plotWTG=true)
# plotstatsdiurnal("TestWTG","dynamicN-insolTRP-sndRCE",plotWTG=true)
# plotstatsdiurnal("TestWTG","dynamicN-insolTRP-sndTRP",plotWTG=true)
# plotstatsdiurnal("TestWTG","dynamicY-insolRCE-sndRCE",plotWTG=true)
# plotstatsdiurnal("TestWTG","dynamicY-insolTRP-sndRCE",plotWTG=true)
# plotstatsdiurnal("TestWTG","dynamicY-insolTRP-sndTRP",plotWTG=true)
#
# plotstatsdiurnal("TestWTG","diurnalN-insolRCE-sndRCE",plotWTG=true)
# plotstatsdiurnal("TestWTG","diurnalN-insolTRP-sndTRP",plotWTG=true)

# plotstatsoverview("DiurnalAmp","SlabInf",plotSST=true)
# plotstatsoverview("DiurnalAmp","Slab10.0",plotSST=true)
# plotstatsoverview("DiurnalAmp","Slab05.0",plotSST=true)
# plotstatsoverview("DiurnalAmp","Slab02.0",plotSST=true)
# plotstatsoverview("DiurnalAmp","Slab01.0",plotSST=true)
# plotstatsoverview("DiurnalAmp","Slab00.5",plotSST=true)
# plotstatsoverview("DiurnalAmp","Slab00.2",plotSST=true)
# plotstatsoverview("DiurnalAmp","Slab00.1",plotSST=true)

plotstatsdiurnal("DiurnalAmp","SlabInf",plotSST=true,days=150)
plotstatsdiurnal("DiurnalAmp","Slab10.0",plotSST=true,days=150)
plotstatsdiurnal("DiurnalAmp","Slab05.0",plotSST=true,days=150)
plotstatsdiurnal("DiurnalAmp","Slab02.0",plotSST=true,days=150)
plotstatsdiurnal("DiurnalAmp","Slab01.0",plotSST=true,days=150)
plotstatsdiurnal("DiurnalAmp","Slab00.5",plotSST=true,days=150)
plotstatsdiurnal("DiurnalAmp","Slab00.2",plotSST=true,days=150)
plotstatsdiurnal("DiurnalAmp","Slab00.1",plotSST=true,days=150)
