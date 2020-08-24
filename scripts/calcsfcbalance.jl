using DrWatson
@quickactivate "DiConv"
using SAMTools

include(srcdir("resort.jl"))

radiationbalance("Insol880.0","FindInsolRCE",prjpath=datadir(),fname="RCE")
radiationbalance("Insol890.0","FindInsolRCE",prjpath=datadir(),fname="RCE")
radiationbalance("Insol900.0","FindInsolRCE",prjpath=datadir(),fname="RCE")
radiationbalance("Insol910.0","FindInsolRCE",prjpath=datadir(),fname="RCE")
radiationbalance("Insol920.0","FindInsolRCE",prjpath=datadir(),fname="RCE")
