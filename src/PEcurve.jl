using Statistics

function randomselect(npnts::Integer,prcp::AbstractArray,tcwv::AbstractArray)

    nx,ny,nt = size(prcp); pii = zeros(Float32,npnts); tii = zeros(Float32,npnts)
    tb = ceil(Int,nt/2)

    for ii = 1 : npnts
        ix = rand(1:nx); iy = rand(1:ny); it = rand(tb:nt)
        pii[ii] = prcp[ix,iy,it]; tii[ii] = tcwv[ix,iy,it];
    end

    return pii,tii

end

function bretherthoncurve(prcp::AbstractArray,tcwv::AbstractArray,swp::AbstractArray)

    fcwv = tcwv ./ swp;
    tvec = 0:0.01:1; tsep = (tvec[2]-tvec[1])/2; jj = 0;
    pvec = zeros(length(tvec))
    pstd = zeros(length(tvec))
    for tii in tvec
        pii = @view prcp[ (fcwv.>(tii-tsep)) .& (fcwv.<(tii+tsep)) ]
        jj = jj + 1; pvec[jj] = mean(pii); pstd[jj] = std(pii)
    end

    return pvec,pstd

end

function bretherthoncurve(prcp::AbstractArray,tcwv::AbstractArray,tvec::AbstractRange)

    tsep = (tvec[2]-tvec[1])/2
    pvec = zeros(length(tvec)); jj = 0;
    pstd = zeros(length(tvec))
    for tii in tvec
        pii = @view prcp[ (tcwv.>(tii-tsep)) .& (tcwv.<(tii+tsep)) ]
        jj = jj + 1; pvec[jj] = mean(pii); pstd[jj] = std(pii)
    end

    return pvec,pstd

end

function bretherthoncurve(
    experiment::AbstractString, config::AbstractString; days::Integer=0
)

    init,sroot = samstartup(
        tmppath="",prjpath=datadir(),fname="RCE_*",
        experiment=experiment,config=config,welcome=false
    )

    nt = convert(Integer,round(1/init["tstep2D"]))

    prcp = collate(init,sroot,modID="m2D",parID="prcp"); prcp = prcp[:,:,(days*nt+1):end]
    tcwv = collate(init,sroot,modID="m2D",parID="tcw");  tcwv = tcwv[:,:,(days*nt+1):end]
    scwv = collate(init,sroot,modID="m2D",parID="swp");  scwv = scwv[:,:,(days*nt+1):end]

    return bretherthoncurve(prcp,tcwv,scwv)

end
