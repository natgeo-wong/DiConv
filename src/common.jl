using NCDatasets
using SAMTools

function domainmean_timeseries(
    init::AbstractDict, sroot::AbstractDict;
    modID::AbstractString, parID::AbstractString
)

    smod,spar,stime = saminitialize(init,modID=modID,parID=parID)
    if occursin("2D",smod["moduletype"]);
          return domainmean_timeseries2D(smod,spar,stime,sroot)
    else; return domainmean_timeseries3D(smod,spar,stime,sroot)
    end

end

function domainmean_timeseries2D(
    smod::AbstractDict, spar::AbstractDict, stime::AbstractDict,
    sroot::AbstractDict
)

    nx,ny,nz = smod["size"]; nt = length(stime["t2D"]); it = stime["it"]; tt = 0;
    nfnc = floor(Int64,nt/it); if rem(nt,it) != 0; nfnc += 1 end
    data = Vector{Float32}(undef,nt);

    for inc = 1 : nfnc

        ids,ivar = samrawread(spar,sroot,irun=inc)

        beg = (inc-1)*stime["it"]+1
        if inc != nfnc; fin = inc*stime["it"];
              data[beg:fin] .= mean(ivar[:],dims=(1,2))[:];
        else; data[beg:end] .= mean(ivar[:],dims=(1,2))[:];
        end

        close(ids)

    end

    return data,stime["t2D"]

end

function domainmean_timeseries3D(
    smod::AbstractDict, spar::AbstractDict, stime::AbstractDict,
    sroot::AbstractDict
)

    nx,ny,nz = smod["size"]; nt = length(stime["t3D"]); it = stime["it"]; tt = 0;
    nfnc = floor(Int64,nt/it); if rem(nt,it) != 0; nfnc += 1 end
    data = Array{Float32,2}(undef,nz,nt);

    for inc = 1 : nfnc

        ids,ivar = samrawread(spar,sroot,irun=inc)

        beg = (inc-1)*stime["it"]+1
        if inc != nfnc; fin = inc*stime["it"];
              data[:,beg:fin] .= dropdims(mean(ivar[:],dims=(1,2)),dims=(1,2));
        else; data[:,beg:end] .= dropdims(mean(ivar[:],dims=(1,2)),dims=(1,2));
        end

        close(ids)

    end

    return data,stime["t3D"]

end

function collate(;
    exp::AbstractString, config::AbstractString,
    modID::AbstractString, parID::AbstractString
)

    init,sroot = samstartup(
        tmppath="",prjpath=datadir(),fname="RCE_*",
        experiment=exp,config=config,welcome=false
    )

    smod,spar,stime = saminitialize(init,modID=modID,parID=parID)
    nx,ny,nz = smod["size"]; nt = length(stime["t2D"]); it = stime["it"]; tt = 0;
    nfnc = floor(Int64,nt/it); if rem(nt,it) != 0; nfnc += 1 end
    data = Array{Float32,3}(undef,nx,ny,nt);

    for inc = 1 : nfnc

        ids,ivar = samrawread(spar,sroot,irun=inc)

        beg = (inc-1)*stime["it"]+1
        if inc != nfnc; fin = inc*stime["it"];
              data[:,:,beg:fin] .= ivar[:]
        else; data[:,:,beg:end] .= ivar[:]
        end

        close(ids)

    end

    return init["x"]/1000,init["y"]/1000,init["t2D"] .- init["day0"] .+ init["dayh"],data

end
