using JLD2
using NCDatasets

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

function plotstatline(t::Vector{<:Real},data::Vector{<:Real},axsii::PyObject)

    axsii.plot(t,data,lw=1);

end

function plotstatcontourf(
    t::Vector{<:Real},z::Vector{<:Real},
    data::AbstractArray{<:Real,2},
    axsii::PyObject
)

    c = axsii.contourf(
        t,z,data,cmap="Blues",
        norm="segmented",levels=[0,1,2,5,10,20,50,80,90,95,99,100]
    ); axsii.colorbar(c,loc="r");

end

function plotstatTAIR(
    t::Vector{<:Real},z::Vector{<:Real},
    tair::AbstractArray{<:Real,2},
    axsii::PyObject
)

    c = axsii.contourf(
        t,z,tair,
    );
    axsii.colorbar(c,loc="r");
    axsii.format(rtitle=L"Large-Scale W-Advect Moisture Tendency / g kg$^{-1}$ hr$^{-1}$")

end

function plotstatTAIRdiurnal(
    t::Vector{<:Real},z::Vector{<:Real},
    tair::AbstractArray{<:Real,2},
    axsii::PyObject
)

    c = axsii.contourf(
        t,z,tair .- mean(tair,dims=2)
    );
    axsii.colorbar(c,loc="r");
    axsii.format(rtitle=L"Large-Scale W-Advect Moisture Tendency / g kg$^{-1}$ hr$^{-1}$")

end

function plotstatWTG(
    t::Vector{<:Real},z::Vector{<:Real},
    wwtg::AbstractArray{<:Real,2},
    axsii::PyObject
)

    c = axsii.contourf(
        t,z,wwtg,cmap="RdBu_r",extend="both",
        norm="segmented",levels=[-20,-10,-5,-2,-1,1,2,5,10,20]/100
    ); axsii.colorbar(c,loc="r");
    axsii.format(rtitle="WTG Induced Vertical Wind / m/s")

end

function retrieveplottingstats(
    experiment::AbstractString, config::AbstractString, plotWTG::Bool=false
)

    rce = NCDataset(datadir(joinpath(
        experiment,config,"OUT_STAT",
        "RCE_DiConv-$(experiment).nc"
    )))

    z  = rce["z"][:]/1000; t = rce["time"][:] .- 80;
    cld = rce["CLD"][:]*100
    rh  = rce["RELH"][:]; tair = rce["TABS"][:];
    pwv = rce["PW"][:];   prcp = rce["PREC"][:]./24
    sst = rce["SST"][:];  wwtg = 0;

    if plotWTG; wwtg = rce["WWTG"][:] end

    return z,t,cld,rh,pwv,prcp,tair,sst,wwtg

end

function t2d(t::Vector{<:Real})

    tstep = round(Integer,(length(t)-1)/(t[end]-t[1]))
    t = mod.(t[(end-tstep+1):end],1); tmin = argmin(t)
    tshift = tstep-tmin+1; t = circshift(t,tshift)
    t = vcat(t[end]-1,t,t[1]+1)

    return t*tstep,tstep,tshift

end

function diurnal(data::Vector{<:Real},tstep::Integer,tshift::Integer)

    data = dropdims(mean(reshape(data,tstep,:),dims=2),dims=2);
    data = circshift(data,tshift)
    return vcat(data[end],data,data[1])

end

function diurnal(data::AbstractArray{<:Real,2},tstep::Integer,tshift::Integer)

    nz = size(data,1)
    data = dropdims(mean(reshape(data,nz,tstep,:),dims=3),dims=3);
    data = circshift(data,(0,tshift))

    return cat(dims=2,data[:,end],data,data[:,1])

end

function plotstatistics(
    experiment::AbstractString, config::AbstractString;
    plotWTG::Bool=false, plotSST::Bool=false
)

    z,t,cld,rh,pwv,prcp,tair,sst,wwtg = retrieveplottingstats(experiment,config,plotWTG)
    cld[cld.==0] .= NaN;

    pplt.close(); f,axs = pplt.subplots(nrows=3,ncols=2,axwidth=4,aspect=2,sharey=0)

    plotstatcontourf(t,z,cld,axs[1]); axs[1].format(rtitle="Cloud Cover Fraction / %")
    plotstatcontourf(t,z,rh,axs[2]);  axs[2].format(rtitle="Relative Humidity / %")
    plotstatTAIR(t,z,tair,axs[3])

    plotstatline(t,pwv,axs[5]);
    axs[5].format(rtitle="Precipitable Water / mm",ylim=(0,70))
    plotstatline(t,prcp,axs[6]);
    axs[6].format(rtitle=L"Precipiation Rate / mm hr$^{-1}$",ylim=(0,5))

    if plotWTG; plotstatWTG(t,z,wwtg,axs[4])
    else
        if plotSST
              plotstatline(t,sst,axs[4]);
              axs[4].format(rtitle="Sea Surface Temperature / K")
        else; plotstatline(t,tair[1,:],axs[4]);
              axs[4].format(rtitle="25m Air Temperature / K")
        end
    end

    axs[1].format(suptitle="$(uppercase(experiment)) | $(uppercase(config))")
    if plotWTG
          for ii = 1 : 4; axs[ii].format(yscale="log") end
    else; for ii = 1 : 3; axs[ii].format(yscale="log") end
    end
    for ii = 1 : 6; axs[ii].format(abc=true,xlim=(150,200),xlabel="Time Elapsed / days") end

    if !isdir(plotsdir("SAM_STAT-SUMMARY")); mkpath(plotsdir("SAM_STAT-SUMMARY")) end
    f.savefig(plotsdir("SAM_STAT-SUMMARY/$(experiment)-$(config).png"),transparent=false,dpi=200)

end

function plotspinup(
    experiment::AbstractString, config::AbstractString;
    plotWTG::Bool=false, plotSST::Bool=false
)

    z,t,cld,rh,pwv,prcp,tair,sst,wwtg = retrieveplottingstats(experiment,config,plotWTG)
    cld[cld.==0] .= NaN;

    pplt.close(); f,axs = pplt.subplots(nrows=3,ncols=2,axwidth=4,aspect=2,sharey=0)

    plotstatcontourf(t,z,cld,axs[1]); axs[1].format(rtitle="Cloud Cover Fraction / %")
    plotstatcontourf(t,z,rh,axs[2]);  axs[2].format(rtitle="Relative Humidity / %")
    plotstatTAIR(t,z,tair,axs[3])

    plotstatline(t,pwv,axs[5]);
    axs[5].format(rtitle="Precipitable Water / mm",ylim=(0,70))
    plotstatline(t,prcp,axs[6]);
    axs[6].format(rtitle=L"Precipiation Rate / mm hr$^{-1}$",ylim=(0,5))

    if plotWTG; plotstatWTG(t,z,wwtg,axs[4])
    else
        if plotSST
              plotstatline(t,sst,axs[4]);
              axs[4].format(rtitle="Sea Surface Temperature / K")
        else; plotstatline(t,tair[1,:],axs[4]);
              axs[4].format(rtitle="25m Air Temperature / K")
        end
    end

    axs[1].format(suptitle="$(uppercase(experiment)) | $(uppercase(config))")
    if plotWTG
          for ii = 1 : 4; axs[ii].format(yscale="log") end
    else; for ii = 1 : 3; axs[ii].format(yscale="log") end
    end
    for ii = 1 : 6; axs[ii].format(abc=true,xlim=(0,50),xlabel="Time Elapsed / days") end

    if !isdir(plotsdir("SAM_STAT-SPINUP")); mkpath(plotsdir("SAM_STAT-SPINUP")) end
    f.savefig(plotsdir("SAM_STAT-SPINUP/$(experiment)-$(config).png"),transparent=false,dpi=200)

end

function plotstatsdiurnal(
    experiment::AbstractString, config::AbstractString;
    plotWTG::Bool=false, plotSST::Bool=false,
    days::Integer=100
)

    z,t,cld,rh,pwv,prcp,tair,sst,wwtg = retrieveplottingstats(experiment,config,plotWTG)

    t,tstep,tshift = t2d(t); beg = days*tstep - 1
    cld  = diurnal(cld[:,(end-beg):end],tstep,tshift); cld[cld.==0] .= NaN;
    rh   = diurnal(rh[:,(end-beg):end],tstep,tshift)
    pwv  = diurnal(pwv[(end-beg):end],tstep,tshift)
    prcp = diurnal(prcp[(end-beg):end],tstep,tshift)
    tair = diurnal(tair[:,(end-beg):end],tstep,tshift)
    sst  = diurnal(sst[(end-beg):end],tstep,tshift)
    if plotWTG; wwtg = diurnal(wwtg[:,(end-beg):end],tstep,tshift) end

    pplt.close(); f,axs = pplt.subplots(nrows=3,ncols=2,axwidth=4,aspect=2,sharey=0)

    plotstatcontourf(t,z,cld,axs[1]); axs[1].format(rtitle="Cloud Cover Fraction / %")
    plotstatcontourf(t,z,rh,axs[2]);  axs[2].format(rtitle="Relative Humidity / %")
    plotstatTAIRdiurnal(t,z,tair,axs[3])

    plotstatline(t,pwv,axs[5]);
    axs[5].format(rtitle="Precipitable Water / mm")
    plotstatline(t,prcp,axs[6]);
    axs[6].format(rtitle=L"Precipiation Rate / mm hr$^{-1}$")

    if plotWTG; plotstatWTG(t,z,wwtg,axs[4])
    else
        if plotSST
              plotstatline(t,sst,axs[4]);
              axs[4].format(rtitle="Sea Surface Temperature / K")
        else; plotstatline(t,tair[1,:],axs[4]);
              axs[4].format(rtitle="25m Air Temperature / K")
        end
    end

    axs[1].format(suptitle="$(uppercase(experiment)) | $(uppercase(config))")
    if plotWTG
          for ii = 1 : 4; axs[ii].format(yscale="log") end
    else; for ii = 1 : 3; axs[ii].format(yscale="log") end
    end
    for ii = 1 : 6; axs[ii].format(abc=true,xlim=(0,tstep),xlabel="Hour of Day") end

    if !isdir(plotsdir("SAM_STAT-DIURNAL")); mkpath(plotsdir("SAM_STAT-DIURNAL")) end
    f.savefig(plotsdir("SAM_STAT-DIURNAL/$(experiment)-$(config).png"),transparent=false,dpi=200)

end
