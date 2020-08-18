using DrWatson
@quickactivate "DiConv"
using SAMTools

include(srcdir("snd.jl"))

createsnd(config="ocean-RCE-insolRCE")
createsnd(config="ocean-RCE-insolTRP")
