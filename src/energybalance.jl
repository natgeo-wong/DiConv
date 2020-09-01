using NCDatasets
using Crayons.Box
using Statistics

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

function ebextract(experiment::AbstractString, config::AbstractString)

    dfnc = joinpath(datadir(experiment,config,"ANA","sfcflux.nc"))
    rce = NCDataset(dfnc)
    t  = rce["t"][:] .- 80
    eb = rce["ebal_sfc"][:]
    sw = rce["sw_net_sfc"][:]
    lw = rce["lw_net_sfc"][:]
    sh = rce["hflux_s"][:]
    lh = rce["hflux_l"][:]
    close(rce)


    return t,eb,sw,lw,sh,lh

end

function ebsummary(experiment::AbstractString, config::AbstractString, days::Integer=100)

    t,eb,sw,lw,sh,lh = ebextract(experiment,config)

    tstep = round(Integer,(length(t) - 1) / (t[end] - t[1]))

    eb = mean(reshape(eb,tstep,:)[:,(end-days+1):end]);
    sw = mean(reshape(sw,tstep,:)[:,(end-days+1):end]);
    lw = mean(reshape(lw,tstep,:)[:,(end-days+1):end]);
    sh = mean(reshape(sh,tstep,:)[:,(end-days+1):end]);
    lh = mean(reshape(lh,tstep,:)[:,(end-days+1):end]);

    @info """We calculate the surface energy balance for:
      $(BOLD("Experiment:"))    $(uppercase(experiment))
      $(BOLD("Configuration:")) $(uppercase(config))

    The following are the summarized statistics for the last $days days:
      $(BOLD("Overall Balance:"))    $eb
      $(BOLD("Shortwave Flux:"))     $sw
      $(BOLD("Longwave Flux:"))      $lw
      $(BOLD("Sensible Heat Flux:")) $sh
      $(BOLD("Latent Heat Flux:"))   $lh
    """

end

function ebplot(experiment::AbstractString, config::AbstractString)

    t,eb,sw,lw,sh,lh = ebextract(experiment,config)

    pplt.close(); arr = [[0,1,1,0],[2,2,3,3],[4,4,5,5]]
    f,axs = pplt.subplots(arr,axwidth=4,aspect=2,sharey=1)

    axs[1].plot(t,eb,lw=1)
    axs[2].plot(t,sw,lw=1)
    axs[3].plot(t,lw,lw=1)
    axs[4].plot(t,sh,lw=1)
    axs[5].plot(t,lh,lw=1)

    axs[1].format(title="Surface Energy Balance",ylabel=L"W m$^{-2}$",xlim=(190,200))
    axs[2].format(title="Net Shortwave",xlim=(190,200))
    axs[3].format(title="Net Longwave",xlim=(190,200))
    axs[4].format(title="Sensible Heat")
    axs[5].format(title="Latent Heat",xlabel=L"Insolation / W m$^{-2}$",ylabel=L"W m$^{-2}$")

    axs[1].format(suptitle="$(uppercase(experiment)) | $(uppercase(config))")

    f.savefig(plotsdir("SFCBALANCE/$(experiment)-$(config).png"),transparent=false,dpi=200)

end
