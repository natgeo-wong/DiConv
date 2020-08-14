using Statistics

include(srcdir("common.jl"));

function getsst(;
    experiment::AbstractString, config::AbstractString
)

    init,sroot = samstartup(
        tmppath="",prjpath=datadir(),fname="RCE_*",
        experiment=experiment,config=config,welcome=false
    )

    sst,t2D = domainmean_timeseries(init,sroot,modID="d2D",parID="t_sst");
    tstep = convert(Integer,round(1/(t2D[2]-t2D[1])))

    return diurnal(sst,tstep),tstep

end

function getprcp(;
    experiment::AbstractString, config::AbstractString
)

    init,sroot = samstartup(
        tmppath="",prjpath=datadir(),fname="RCE_*",
        experiment=experiment,config=config,welcome=false
    )

    prcp,t2D = domainmean_timeseries(init,sroot,modID="m2D",parID="prcp");
    tstep = convert(Integer,round(1/(t2D[2]-t2D[1])))

    return diurnal(prcp,tstep),tstep

end

function gettcw(;
    experiment::AbstractString, config::AbstractString
)

    init,sroot = samstartup(
        tmppath="",prjpath=datadir(),fname="RCE_*",
        experiment=experiment,config=config,welcome=false
    )

    tcw,t2D = domainmean_timeseries(init,sroot,modID="m2D",parID="tcw");
    tstep = convert(Integer,round(1/(t2D[2]-t2D[1])))

    return diurnal(tcw,tstep),tstep

end

function getsol(;
    experiment::AbstractString, config::AbstractString
)

    init,sroot = samstartup(
        tmppath="",prjpath=datadir(),fname="RCE_*",
        experiment=experiment,config=config,welcome=false
    )

    tcw,t2D = domainmean_timeseries(init,sroot,modID="r2D",parID="sol_net_toa");
    tstep = convert(Integer,round(1/(t2D[2]-t2D[1])))

    return diurnal(tcw,tstep),tstep

end

function diurnal(var::Vector{<:Real},tstep::Integer)

    lt = length(var); nday = floor(Integer,lt/tstep)
    var = @view var[1:nday*tstep];
    return dropdims(mean(reshape(var,tstep,:),dims=2),dims=2)

end
