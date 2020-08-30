using SAMTools

samwelcome()

function resort2D(init::AbstractDict,sroot::AbstractDict)

    samresort(init,sroot,modID="d2D",parID="u_sfc")
    samresort(init,sroot,modID="d2D",parID="v_sfc")
    samresort(init,sroot,modID="d2D",parID="p_sfc")
    samresort(init,sroot,modID="m2D",parID="prcp")
    samresort(init,sroot,modID="m2D",parID="tcw")
    samresort(init,sroot,modID="m2D",parID="swp")
    samresort(init,sroot,modID="r2D",parID="sol_net_toa")

end

function resortrad(init::AbstractDict,sroot::AbstractDict)

    samresort(init,sroot,modID="r2D",parID="hflux_s")
    samresort(init,sroot,modID="r2D",parID="hflux_l")
    samresort(init,sroot,modID="r2D",parID="sw_net_sfc")
    samresort(init,sroot,modID="r2D",parID="lw_net_sfc")
    samresort(init,sroot,modID="r2D",parID="sol_net_toa")

end

function resortsst(init::AbstractDict,sroot::AbstractDict)

    samresort(init,sroot,modID="d2D",parID="t_sst")

end

function resort3D(init::AbstractDict,sroot::AbstractDict)

    samresort(init,sroot,modID="s3D",parID="u_air")
    samresort(init,sroot,modID="s3D",parID="v_air")
    samresort(init,sroot,modID="s3D",parID="w_air")
    samresort(init,sroot,modID="s3D",parID="p_ptb")
    samresort(init,sroot,modID="s3D",parID="rad_dt")
    samresort(init,sroot,modID="s3D",parID="t_abs")
    samresort(init,sroot,modID="s3D",parID="q_vap")
    samresort(init,sroot,modID="s3D",parID="q_con")
    samresort(init,sroot,modID="s3D",parID="q_prcp")

end

function resortdiconv(
    experiment::AbstractString, config::AbstractString;
    pdir::AbstractString, fname::AbstractString,
    do2D::Bool=true, do3D::Bool=true, dosst::Bool=false
)

    init,sroot = samstartup(
        prjpath=pdir,fname=fname,
        experiment=experiment,config=config,
        loadinit=false,welcome=false
    )

    if do2D;  resort2D(init,sroot)  end
    if do3D;  resort3D(init,sroot)  end
    if dosst; resortsst(init,sroot) end

end

function resortsfctest(
    experiment::AbstractString, config::AbstractString;
    pdir::AbstractString, fname::AbstractString,
    dosst::Bool=false
)

    init,sroot = samstartup(
        prjpath=pdir,fname=fname,
        experiment=experiment,config=config,
        loadinit=false,welcome=false
    ); resortrad(init,sroot)

    if dosst; resortsst(init,sroot) end

end
