using SAMTools

function createsnd(;
    exp::AbstractString="control", config::AbstractString, ndays::Integer=100
)
    mkpath(projectdir("exp/snd")); fsnd = projectdir("exp/snd/$(config)")
    samsnd(fsnd,prjpath=datadir(),fname="RCE",experiment=exp,config=config,ndays=ndays)

end
