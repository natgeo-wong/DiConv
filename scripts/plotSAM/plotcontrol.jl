using DrWatson
@quickactivate "DiConv"
using NCDatasets
using SAMTools
using Statistics

include(srcdir("plots.jl"))
mkpath(plotsdir("SAM_STAT"))

plotcteststats(insolation=900.0,istest=true)
# plotcteststats(insolation=910.0)
# plotcteststats(insolation=920.0)
# plotcteststats(insolation=930.0)
# plotcteststats(insolation=940.0)
# plotcteststats(insolation=950.0)
# plotcteststats(insolation=960.0)
# plotcteststats(insolation=970.0)
# plotcteststats(insolation=980.0)
