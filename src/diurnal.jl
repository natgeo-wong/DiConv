using Statistics

include(srcdir("common.jl"));

function getdiurnal(
    experiment::AbstractString, config::AbstractString;
    modID::AbstractString, parID::AbstractString, days::Integer=0
)

    init,sroot = samstartup(
        tmppath="",prjpath=datadir(),fname="RCE_*",
        experiment=experiment,config=config,welcome=false
    )

    data,t2D = domainmean_timeseries(init,sroot,modID=modID,parID=parID);
    tstep = convert(Integer,round(1/(t2D[2]-t2D[1])))

    return diurnal(removespin(data,tstep,days=days),tstep),tstep

end

function diurnal(var::Vector{<:Real},tstep::Integer)

    lt = length(var); nday = floor(Integer,lt/tstep)
    var = @view var[1:nday*tstep];
    return dropdims(mean(reshape(var,tstep,:),dims=2),dims=2)

end

function removespin(vec::Vector,tstep::Integer; days::Integer)

    return vec[(days*tstep+1):end]

end
