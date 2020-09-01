using SAMTools
using Statistics
using StatsBase

include(srcdir("common.jl"))

function prcp2hist(
    experiment::AbstractString, config::AbstractString;
    avg2D::Bool=true
)

    init,sroot = samstartup(
        prjpath=datadir(),fname="RCE_*",
        experiment=experiment,config=config,
        loadinit=true,welcome=false
    )

    if avg2D
          prcp,_ = domainmean_timeseries(init,sroot,modID="m2D",parID="prcp")
    else; prcp   = collate(init,sroot,modID="m2D",parID="prcp")
    end

    prcp = prcp/24;

    if avg2D
          edges = 0:0.02:10; w = fit(Histogram,prcp[:],edges).weights
    else; edges = 0:0.5:100; w = fit(Histogram,prcp[:],edges).weights
    end

    return edges,w,mean(prcp)

end

function csf2hist(
    experiment::AbstractString, config::AbstractString;
    avg2D::Bool=true
)

    init,sroot = samstartup(
        prjpath=datadir(),fname="RCE_*",
        experiment=experiment,config=config,
        loadinit=true,welcome=false
    )

    tcw = collate(init,sroot,modID="m2D",parID="tcw")
    swp = collate(init,sroot,modID="m2D",parID="swp")
    csf = tcw ./ swp; if avg2D; csf = dropdims(mean(csf,dims=(1,2)),dims=(1,2)) end

    edges = (0:100)/100; w = fit(Histogram,csf[:],edges).weights

    return edges,w,mean(csf)

end
