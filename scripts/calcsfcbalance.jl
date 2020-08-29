using DrWatson
@quickactivate "DiConv"
using SAMTools

# radiationbalance("dynamicN-insolRCE-sndRCE","TestWTG",prjpath=datadir(),fname="RCE")
# radiationbalance("dynamicN-insolTRP-sndRCE","TestWTG",prjpath=datadir(),fname="RCE")
# radiationbalance("dynamicN-insolTRP-sndTRP","TestWTG",prjpath=datadir(),fname="RCE")
# radiationbalance("dynamicY-insolRCE-sndRCE","TestWTG",prjpath=datadir(),fname="RCE")
# radiationbalance("dynamicY-insolTRP-sndRCE","TestWTG",prjpath=datadir(),fname="RCE")
# radiationbalance("dynamicY-insolTRP-sndTRP","TestWTG",prjpath=datadir(),fname="RCE")

radiationbalance("diurnalN-insolRCE-sndRCE","TestWTG",prjpath=datadir(),fname="RCE")
radiationbalance("diurnalN-insolTRP-sndTRP","TestWTG",prjpath=datadir(),fname="RCE")
