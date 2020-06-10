using DrWatson
@quickactivate "DiConv"

using NCDatasets
using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

fnc = datadir("RCE_test/RCE_128x128x64_32.2Dcom_2.nc"); rce = Dataset(fnc)

x = rce["x"][:]/1000; y = rce["y"][:]/1000; t = rce["time"][:]; prcp = rce["Prec"];
nx = length(x); ny = length(y); nt = length(t);

pplt.close(); f,axs = pplt.subplots()

for it = 3 : 3 : nt
    axs[1].cla(); axs[1].contourf(
        x,y,log10.(prcp[:,:,it]'),
        cmap="Blues",levels=-2:0.5:4,extend="both"
    )
    axs[1].format(xlim=(0,255),ylim=(0,255))
    f.savefig(plotsdir("RCEtest_$(@sprintf("%02d",it/3)).png"),transparent=false,dpi=200)
end

close(rce)
