using DrWatson
@quickactivate "DiConv"
using JLD2
using NCDatasets

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

include(srcdir("common.jl"));

x,y,t,prcp = collate(exp="control_tests",config="insol950.0",modID="m2D",parID="prcp")
_,_,_,tcw  = collate(exp="control_tests",config="insol950.0",modID="m2D",parID="tcw")
nt = length(t); prcp[prcp.==0] .= NaN; prcp .= prcp/24

for it = (nt-96*5+1) : nt

    pplt.close(); f,axs = pplt.subplots(axwidth=4)
    c = axs[1].contourf(
        x,y,prcp[:,:,it]',cmap="Blues",extend="max",
        norm="segmented",levels=[0,1,10,20,50,100]
    );
    axs[1].contour(
        x,y,tcw[:,:,it]' .- mean(tcw[:,:,it]),lw=0.5,color="k",labels=true,
        norm="segmented",levels=[-10,-5,-2,2,5,10]
    )
    axs[1].format(
        xlabel="X / km",ylabel="Y / km",
        ltitle="Time: Day $(floor(t[it])), Hour $(round(mod(t[it],1)*24,digits=2))"
    )
    f.colorbar(c,loc="r",label=L"Precipitation Rate / mm hr$^{-1}$")
    f.savefig(plotsdir("spatial/$(@sprintf("%03d",it)).png"),transparent=false,dpi=200)

end
