using Statistics

include(srcdir("common.jl"));

function getdiurnal2D(
    experiment::AbstractString, config::AbstractString;
    modID::AbstractString, parID::AbstractString, days::Integer=0
)

    init,sroot = samstartup(
        tmppath="",prjpath=datadir(),fname="RCE_*",
        experiment=experiment,config=config,welcome=false
    )

    data,t2D = domainmean_timeseries(init,sroot,modID=modID,parID=parID);
    tstep = convert(Integer,round(1/init["tstep2D"]))

    return diurnal(removespin(data,tstep,days=days),tstep),tstep

end

function getdiurnal3D(
    experiment::AbstractString, config::AbstractString;
    modID::AbstractString, parID::AbstractString, days::Integer=0
)

    init,sroot = samstartup(
        tmppath="",prjpath=datadir(),fname="RCE_*",
        experiment=experiment,config=config,welcome=false
    )

    data,z,t3D = domainmean_timeseries(init,sroot,modID=modID,parID=parID);
    tstep = convert(Integer,round(1/init["tstep3D"]))

    return diurnal(removespin(data,tstep,days=days),tstep),z,tstep

end

function diurnal(var::Vector{<:Real},tstep::Integer)

    nt = length(var); nday = floor(Integer,nt/tstep)
    var = @view var[1:nday*tstep];
    return dropdims(mean(reshape(var,tstep,:),dims=2),dims=2)

end

function diurnal(var::AbstractArray{<:Real,2},tstep::Integer)

    nz,nt = size(var); nday = floor(Integer,nt/tstep)
    var = @view var[:,1:nday*tstep];
    return dropdims(mean(reshape(var,nz,tstep,:),dims=3),dims=3)

end

function removespin(data::Vector,tstep::Integer; days::Integer)

    return data[(days*tstep+1):end]

end

function removespin(data::AbstractArray{<:Real,2},tstep::Integer; days::Integer)

    return data[:,(days*tstep+1):end]

end
