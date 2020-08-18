using JLD2
using NCDatasets

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

include(srcdir("common.jl"))

function plotteststats(;
    iswtg::Bool=false, isdiurnal::Bool=false, isdynamic::Bool=false,
    temp::Real=0, slab::Real=1
)

    if iswtg
          wtgID = "wtgY"; lat = 0
    else; wtgID = "wtgN"; lat = 45
    end

    if isdiurnal; diID = "diurnalY"; else; diID = "diurnalN" end
    if isdiurnal && isdynamic
        if slab == 0
            error("Diurnal Cycle and Dynamic Ocean, but Slab Depth not defined.")
        end
        if typeof(slab) <: Integer
              sstID = "dynamicSST-slab$(@sprintf("%02d",slab))"
        else; sstID = "dynamicSST-slab$(@sprintf("%2.1f",slab))"
        end
    else
        if temp == 0
            error("Sea Surface Temperature not defined.")
        end
        sstID = "fixedSST-temp$(@sprintf("%3d",temp))"
    end

    exp = "$(wtgID)-$(diID)"
    fID = "RCE_$(diID)-$(sstID).nc"
    rce = NCDataset(datadir(joinpath(exp,sstID,"OUT_STAT",fID)))
    @load datadir(joinpath(exp,sstID,"RAW","init.jld2")) init

    z  = rce["z"][:]/1000; t = rce["time"][:] .- init["day0"] .+ init["dayh"];
    cld = rce["CLD"][:]*100; rh = rce["RELH"][:]; tair = rce["TABS"][:];
    pwv = rce["PW"][:]; prcp = rce["PREC"][:]./24

    if iswtg; wwtg = rce["WWTG"][:] end

    cld[cld.==0] .= NaN;

    pplt.close(); f,axs = pplt.subplots(nrows=3,ncols=2,axwidth=4,aspect=2,sharey=0)

    c = axs[1].contourf(t,z,cld,norm="segmented",levels=[0,1,2,5,10,20,50,80,90,100]);
    axs[1].colorbar(c,loc="r"); axs[1].format(rtitle="Cloud Cover Fraction / %")

    c = axs[2].contourf(t,z,rh,norm="segmented",levels=[0,1,2,5,10,20,50,80,90,100]);
    axs[2].colorbar(c,loc="r"); axs[2].format(rtitle="Relative Humidity / %")

    c = axs[3].contourf(t,z,tair,levels=150:10:300,);
    axs[3].colorbar(c,loc="r",ticks=30); axs[3].format(rtitle="Air Temperature / K")

    axs[5].plot(t,pwv,lw=1); axs[5].format(
        xlim=(0,70),ylim=(0,70),
        rtitle="Precipitable Water / mm"
    )
    axs[6].plot(t,prcp,lw=1); axs[6].format(
        xlim=(0,70),ylim=(0,5),
        rtitle=L"Precipiation Rate / mm hr$^{-1}$",
        suptitle=string(
            "Slab Depth = $(@sprintf("%2.1f",slab)) m, Latitude0 = 0",
            L"$\degree$",", WTG = $(uppercase(string(iswtg)))"
        )
    )

    if iswtg
        c = axs[4].contourf(t,z,wwtg.*3.6,levels=0:0.1:1,extend="min");
        axs[4].colorbar(c,loc="r"); axs[4].format(rtitle="Induced Vertical Wind / km/hr")
    end

    for ii = 1 : 3; axs[ii].format(ylim=(0,20)) end
    for ii = 1 : 6; axs[ii].format(abc=true,xlabel="Time Elapsed / days") end

    f.savefig(plotsdir("SAM_STAT/$(wtgID)-$(diID)-$(sstID).png"),transparent=false,dpi=200)

    return init

end

function plotwtglatitude(;
    lat::Integer, domain::Integer
)

    ID = "wtgY-latitude$(lat)";
    ds = NCDataset(datadir("wtgY-latitudes-$(domain)km/RCE_$(ID).nc"))

    z  = ds["z"][:]/1000; t = ds["time"][:] .- 80.5 .+ 0.5; cld = ds["CLD"][:]*100
    rh = ds["RELH"][:];
    pwv = ds["PW"][:]; prcp = ds["PREC"][:]./24
    tair = ds["TABS"][:]; wwtg = ds["WWTG"][:]
    close(ds)

    pplt.close(); f,axs = pplt.subplots(nrows=3,ncols=2,axwidth=4,aspect=2,sharey=0)
    cld[cld.==0] .= NaN;

    c = axs[1].contourf(
        t,z,cld,
        norm="segmented",levels=[0,1,2,5,10,20,50,80,90,100]
    ); axs[1].colorbar(c,loc="r"); axs[1].format(rtitle="Cloud Cover Fraction / %")

    c = axs[2].contourf(
        t,z,rh,
        norm="segmented",levels=[0,1,2,5,10,20,50,80,90,100]
    ); axs[2].colorbar(c,loc="r"); axs[2].format(rtitle="Relative Humidity / %")

    c = axs[3].contourf(
        t,z,tair,levels=150:10:300,
    ); axs[3].colorbar(c,loc="r",ticks=30); axs[3].format(rtitle="Air Temperature / K")

    axs[5].plot(t,pwv,lw=1); axs[5].format(
        xlim=(0,70),ylim=(0,70),
        rtitle="Precipitable Water / mm"
    )
    axs[6].plot(t,prcp,lw=1); axs[6].format(
        xlim=(0,70),ylim=(0,5),
        rtitle=L"Precipiation Rate / mm hr$^{-1}$",
        suptitle=L"Slab Depth = 1m, Latitude0 = 0$\degree$, WTG = True"
    )

    c = axs[4].contourf(
        t,z,wwtg.*3.6,levels=0:0.1:1,extend="min",
        #norm="segmented",levels=[0,1,2,5,10,20,50,80,90,100]
    );
    axs[4].colorbar(c,loc="r");
    axs[4].format(rtitle="Induced Vertical Wind / km/hr")

    for ii = 1 : 3; axs[ii].format(ylim=(0,20)) end
    for ii = 1 : 6; axs[ii].format(abc=true,xlabel="Time Elapsed / days") end

    f.savefig(plotsdir("wtgtests/RCEtest_$ID-$(domain)km.png"),transparent=false,dpi=200)

end

function plotcteststats(;
    insolation::Real, istest::Bool=false
)

    experiment = "control_tests"; config = "insol$(@sprintf("%5.1f",insolation))"

    if istest
          fID = "RCE_DiConv-ControlTest-test.nc"
    else; fID = "RCE_DiConv-ControlTest.nc"
    end

    rce = NCDataset(datadir(joinpath(experiment,config,"OUT_STAT",fID)))

    z  = rce["z"][:]/1000; t = rce["time"][:] .- 80.5;
    cld = rce["CLD"][:]*100; rh = rce["RELH"][:]; tair = rce["TABS"][:];
    pwv = rce["PW"][:]; prcp = rce["PREC"][:]./24; t_sst = rce["SST"][:];

    cld[cld.==0] .= NaN;

    pplt.close(); f,axs = pplt.subplots(nrows=3,ncols=2,axwidth=4,aspect=2,sharey=0)

    c = axs[1].contourf(t,z,cld,norm="segmented",levels=[0,1,2,5,10,20,50,80,90,100]);
    axs[1].colorbar(c,loc="r"); axs[1].format(rtitle="Cloud Cover Fraction / %")

    c = axs[2].contourf(t,z,rh,norm="segmented",levels=[0,1,2,5,10,20,50,80,90,100]);
    axs[2].colorbar(c,loc="r"); axs[2].format(rtitle="Relative Humidity / %")

    c = axs[3].contourf(t,z,tair,levels=150:10:300,);
    axs[3].colorbar(c,loc="r",ticks=30); axs[3].format(rtitle="Air Temperature / K")

    axs[4].plot(t,t_sst,lw=1); axs[4].format(
        xlim=(0,70),ylim=(300,310),
        rtitle="Sea Surface Temperature / K"
    )
    axs[5].plot(t,pwv,lw=1); axs[5].format(
        xlim=(0,70),ylim=(0,70),
        rtitle="Precipitable Water / mm"
    )
    axs[6].plot(t,prcp,lw=1); axs[6].format(
        xlim=(0,70),ylim=(0,0.5),
        rtitle=L"Precipiation Rate / mm hr$^{-1}$",
        suptitle=string("Insolation = $(insolation) ",L"W m$^{-2}$")
    )

    for ii = 1 : 3; axs[ii].format(ylim=(0,20)) end
    for ii = 1 : 6; axs[ii].format(abc=true,xlabel="Time Elapsed / days") end

    if istest
          f.savefig(plotsdir("SAM_STAT/$(experiment)-$(config)-t.png"),transparent=false)
    else; f.savefig(plotsdir("SAM_STAT/$(experiment)-$(config).png"),transparent=false)
    end

end

function plotcontrolstats(;
    isocean::Bool, iswtg::Bool=false, isrce::Bool=true
)

    if isocean; sfc = "ocean"; else; sfc = "land" end
    if iswtg;   wtg = "wtg";   else; wtg = "rce"  end
    if isrce;   rce = "rce";   else; rce = "trp"  end

    experiment = "control"
    config = "$isocean-$(uppercase(iswtg))-insol$(uppercase(rce))"
    fID = "RCE_DiConv-Control.nc"
    rce = NCDataset(datadir(joinpath(experiment,config,"OUT_STAT",fID)))

    z  = rce["z"][:]/1000; t = rce["time"][:] .- 80.5;
    cld = rce["CLD"][:]*100; rh = rce["RELH"][:]; tair = rce["TABS"][:];
    pwv = rce["PW"][:]; prcp = rce["PREC"][:]./24; t_sst = rce["SST"][:];

    cld[cld.==0] .= NaN;

    close(rce)

    pplt.close(); f,axs = pplt.subplots(nrows=3,ncols=2,axwidth=4,aspect=2,sharey=0)

    c = axs[1].contourf(t,z,cld,norm="segmented",levels=[0,1,2,5,10,20,50,80,90,100]);
    axs[1].colorbar(c,loc="r"); axs[1].format(rtitle="Cloud Cover Fraction / %")

    c = axs[2].contourf(t,z,rh,norm="segmented",levels=[0,1,2,5,10,20,50,80,90,100]);
    axs[2].colorbar(c,loc="r"); axs[2].format(rtitle="Relative Humidity / %")

    c = axs[3].contourf(t,z,tair,levels=150:10:300,);
    axs[3].colorbar(c,loc="r",ticks=30); axs[3].format(rtitle="Air Temperature / K")

    axs[4].plot(t,t_sst,lw=1); axs[4].format(
        xlim=(0,70),ylim=(300,310),
        rtitle="Sea Surface Temperature / K"
    )
    axs[5].plot(t,pwv,lw=1); axs[5].format(
        xlim=(0,70),ylim=(0,70),
        rtitle="Precipitable Water / mm"
    )
    axs[6].plot(t,prcp,lw=1); axs[6].format(
        xlim=(0,70),ylim=(0,0.5),
        rtitle=L"Precipiation Rate / mm hr$^{-1}$",
        suptitle=string("Insolation = $(insolation) ",L"W m$^{-2}$")
    )

    for ii = 1 : 3; axs[ii].format(ylim=(0,20)) end
    for ii = 1 : 6; axs[ii].format(abc=true,xlabel="Time Elapsed / days") end

    if istest
          f.savefig(plotsdir("SAM_STAT/$(experiment)-$(config)-t.png"),transparent=false)
    else; f.savefig(plotsdir("SAM_STAT/$(experiment)-$(config).png"),transparent=false)
    end

end
