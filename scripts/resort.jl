using DrWatson
@quickactivate "DiConv"

using SAMTools

pdir = datadir("SAM")
fnc  = "RCE"

function resortall(init::AbstractDict,sroot::AbstractDict)

    samresort(init,sroot,modID="d2D",parID="t_sst")
    samresort(init,sroot,modID="m2D",parID="prcp")
    samresort(init,sroot,modID="m2D",parID="tcw")
    samresort(init,sroot,modID="m2D",parID="swp")
    samresort(init,sroot,modID="r2D",parID="sol_net_toa")

end

init,sroot = samstartup(
    prjpath=pdir,
    config="diurnalN_wtgN_qforceN",fname=fnc,
    loadinit=false
); resortall(init,sroot)


init,sroot = samstartup(
    prjpath=pdir,
    config="diurnalY_wtgN_qforceN",fname=fnc,
    loadinit=false
); resortall(init,sroot)

init,sroot = samstartup(
    prjpath=pdir,
    config="diurnalY_wtgY_qforceN",fname=fnc,
    loadinit=false
); resortall(init,sroot)
