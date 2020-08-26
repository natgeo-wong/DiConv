using DrWatson
@quickactivate "DiConv"
using SAMTools

include(srcdir("snd.jl"))

createsnd("insolRCE",exp="RCEProfile",config="InsolRCE")
createsnd("insolTRP",exp="RCEProfile",config="InsolTRP")
