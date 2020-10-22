using NCDatasets
using Statistics

prect(N::Real,S::Real,W::Real,E::Real) = [W,E,E,W,W],[S,S,N,N,S]

function ncoffsetscale(data::Array{<:Real})

    dmax = maximum(data); dmin = minimum(data);
    scale = (dmax-dmin) / 65533;
    offset = (dmax+dmin-scale) / 2;

    return scale,offset

end

function compilesave(varname::AbstractString)

    tds  = NCDataset(datadir("reanalysis/era5-TRPx0.25-sfc.nc"))
    var  = dropdims(mean(tds[varname][:]*1,dims=3),dims=3)
    lon  = tds["longitude"][:]*1
    lat  = tds["latitude"][:]*1

    fnc = datadir("reanalysis/era5-TRPx0.25-$varname-sfc.nc")
    ds = NCDataset(fnc,"c",attrib = Dict(
        "Conventions"               => "CF-1.6",
        "history"                   => "2020-10-21 23:54:22 GMT by grib_to_netcdf-2.16.0: /opt/ecmwf/eccodes/bin/grib_to_netcdf -S param -o /cache/data4/adaptor.mars.internal-1603323636.0468726-6113-3-fb54412a-f0a5-4783-956d-46233705e403.nc /cache/tmp/fb54412a-f0a5-4783-956d-46233705e403-adaptor.mars.internal-1603323636.0477095-6113-1-tmp.grib",
    ))

    # Dimensions

    ds.dim["longitude"] = length(lon)
    ds.dim["latitude"]  = length(lat)

    # Declare variables

    nclon = defVar(ds,"longitude",Float32,("longitude",),attrib = Dict(
        "units"                     => "degrees_east",
        "long_name"                 => "longitude",
    ))

    nclat = defVar(ds,"latitude",Float32,("latitude",),attrib = Dict(
        "units"                     => "degrees_north",
        "long_name"                 => "latitude",
    ))

    scale,offset = ncoffsetscale(var)

    varattribs = Dict(
        "scale_factor"  => scale,
        "add_offset"    => offset,
        "_FillValue"    => Int16(-32767),
        "missing_value" => Int16(-32767),
        "units"         => tds[varname].attrib["units"],
        "long_name"     => tds[varname].attrib["long_name"],
    )

    if haskey(tds[varname].attrib,"standard_name")
        varattribs["standard_name"] = tds[varname].attrib["standard_name"]
    end

    ncvar = defVar(ds,varname,Int16,("longitude","latitude"),attrib = varattribs)

    nclon[:] = lon
    nclat[:] = lat
    ncvar[:] = var

    close(ds)

    close(tds)

end
