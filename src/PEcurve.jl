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

function bretherthoncurve(;
    pdir::AbstractString, fnc::AbstractString,
    experiment::AbstractString, config::AbstractString
)

    init,sroot = samstartup(
        tmppath="",prjpath=pdir,fname=fnc,
        experiment=experiment,config=config,welcome=false
    )

    prcp = collate(init,sroot,modID="m2D",parID="prcp"); prcp = prcp[:,:,1921:end]
    tcwv = collate(init,sroot,modID="m2D",parID="tcw");  tcwv = tcwv[:,:,1921:end]
    scwv = collate(init,sroot,modID="m2D",parID="swp");  scwv = scwv[:,:,1921:end]

    return bretherthoncurve(prcp,tcwv,scwv)

end
