using DrWatson
@quickactivate "DiConv"

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

include(srcdir("common.jl"))
include(srcdir("PEcurve.jl"))

pe0,_ = bretherthoncurve("DiurnalAmp","SlabInf")
pe1,_ = bretherthoncurve("DiurnalAmp","Slab20.0")
pe2,_ = bretherthoncurve("DiurnalAmp","Slab10.0")
pe3,_ = bretherthoncurve("DiurnalAmp","Slab05.0")
pe4,_ = bretherthoncurve("DiurnalAmp","Slab02.0")
pe5,_ = bretherthoncurve("DiurnalAmp","Slab01.0")
pe6,_ = bretherthoncurve("DiurnalAmp","Slab00.5")
pe7,_ = bretherthoncurve("DiurnalAmp","Slab00.2")
pe8,_ = bretherthoncurve("DiurnalAmp","Slab00.1")

pplt.close(); f,axs = pplt.subplots(axwidth=3,aspect=1.5)

axs[1].plot(0:0.01:1,pe0./24,lw=1,c="k",label="Fixed",legend="ul")
axs[1].plot(0:0.01:1,pe1./24,lw=1,label="20.0",legend="ul")
axs[1].plot(0:0.01:1,pe2./24,lw=1,label="10.0",legend="ul")
axs[1].plot(0:0.01:1,pe3./24,lw=1,label="05.0",legend="ul")
axs[1].plot(0:0.01:1,pe4./24,lw=1,label="02.0",legend="ul")
axs[1].plot(0:0.01:1,pe5./24,lw=1,label="01.0",legend="ul")
axs[1].plot(0:0.01:1,pe6./24,lw=1,label="00.5",legend="ul")
axs[1].plot(0:0.01:1,pe7./24,lw=1,label="00.2",legend="ul")
axs[1].plot(0:0.01:1,pe8./24,lw=1,label="00.1",legend="ul")

axs[1].format(
    ylabel=L"Precipitation Rate / mm hr$^{-1}$",
    xlabel="Column Saturation Fraction",
    xlim=(0.6,1),ylim=(0.01,100),yscale="log"
)

f.savefig(plotsdir("SAM_PLOTS/tcwvVprcp.png"),transparent=false,dpi=200)
