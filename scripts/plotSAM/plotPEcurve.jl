using DrWatson
@quickactivate "DiConv"

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

include(srcdir("common.jl"))
include(srcdir("PEcurve.jl"))

pvecN0,_ = bretherthoncurve(
    pdir=datadir(),fnc="RCE_*",
    experiment="wtgN-diurnalY",config="dynamicSST-slab0.1"
)

pvecN1,_ = bretherthoncurve(
    pdir=datadir(),fnc="RCE_*",
    experiment="wtgN-diurnalY",config="dynamicSST-slab0.2"
)

pvecN2,_ = bretherthoncurve(
    pdir=datadir(),fnc="RCE_*",
    experiment="wtgN-diurnalY",config="dynamicSST-slab0.5"
)

pvecN3,_ = bretherthoncurve(
    pdir=datadir(),fnc="RCE_*",
    experiment="wtgN-diurnalY",config="dynamicSST-slab01"
)

pvecN4,_ = bretherthoncurve(
    pdir=datadir(),fnc="RCE_*",
    experiment="wtgN-diurnalY",config="fixedSST-temp303"
)

pvecN5,_ = bretherthoncurve(
    pdir=datadir(),fnc="RCE_*",
    experiment="wtgN-diurnalN",config="fixedSST-temp303"
)

pvecY0,_ = bretherthoncurve(
    pdir=datadir(),fnc="RCE_*",
    experiment="wtgY-diurnalY",config="dynamicSST-slab0.1"
)

pvecY1,_ = bretherthoncurve(
    pdir=datadir(),fnc="RCE_*",
    experiment="wtgY-diurnalY",config="dynamicSST-slab0.2"
)

pvecY2,_ = bretherthoncurve(
    pdir=datadir(),fnc="RCE_*",
    experiment="wtgY-diurnalY",config="dynamicSST-slab0.5"
)

pvecY3,_ = bretherthoncurve(
    pdir=datadir(),fnc="RCE_*",
    experiment="wtgY-diurnalY",config="dynamicSST-slab01"
)

pvecY4,_ = bretherthoncurve(
    pdir=datadir(),fnc="RCE_*",
    experiment="wtgY-diurnalY",config="fixedSST-temp305"
)

pvecY5,_ = bretherthoncurve(
    pdir=datadir(),fnc="RCE_*",
    experiment="wtgY-diurnalN",config="fixedSST-temp305"
)

pplt.close(); f,axs = pplt.subplots(ncols=2,axwidth=3,aspect=1.5)

axs[1].plot(0:0.01:1,pvecN4./24,lw=1,c="k",label="Fixed",legend="ul")
axs[1].plot(0:0.01:1,pvecN5./24,lw=1,c="k",linestyle=":")
axs[1].plot(0:0.01:1,pvecN0./24,lw=1,label="0.1 m",legend="ul")
axs[1].plot(0:0.01:1,pvecN1./24,lw=1,label="0.2 m",legend="ul")
axs[1].plot(0:0.01:1,pvecN2./24,lw=1,label="0.5 m",legend="ul")
axs[1].plot(0:0.01:1,pvecN3./24,lw=1,label="1.0 m",legend="ul")

axs[2].plot(0:0.01:1,pvecY4./24,lw=1,c="k",label="Fixed",legend="ul")
axs[2].plot(0:0.01:1,pvecY5./24,lw=1,c="k",linestyle=":")
axs[2].plot(0:0.01:1,pvecY0./24,lw=1,label="0.1 m",legend="ul")
axs[2].plot(0:0.01:1,pvecY1./24,lw=1,label="0.2 m",legend="ul")
axs[2].plot(0:0.01:1,pvecY2./24,lw=1,label="0.5 m",legend="ul")
axs[2].plot(0:0.01:1,pvecY3./24,lw=1,label="1.0 m",legend="ul")

axs[1].format(
    ylabel=L"Precipitation Rate / mm hr$^{-1}$",
    xlabel="Column Saturation Fraction",
    xlim=(0.6,1),ylim=(0.01,100),yscale="log",
    rtitle="WTG: FALSE",abc=true
)

axs[2].format(
    ylabel=L"Precipitation Rate / mm hr$^{-1}$",
    xlabel="Column Saturation Fraction",
    xlim=(0.6,1),ylim=(0.01,100),yscale="log",
    rtitle="WTG: TRUE",abc=true
)

f.savefig(plotsdir("SAM_PLOTS/tcwvVprcp.png"),transparent=false,dpi=200)
