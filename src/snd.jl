using SAMTools

function createsnd(
    sndname::AbstractString;
    exp::AbstractString, config::AbstractString, ndays::Integer=100
)
    mkpath(projectdir("exp/snd")); fsnd = projectdir("exp/snd/$(sndname)")
    samsnd(fsnd,prjpath=datadir(),fname="RCE",experiment=exp,config=config,ndays=ndays)

end
