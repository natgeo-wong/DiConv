using DrWatson
@quickactivate "DiConv"

using PyCall
using LaTeXStrings
pplt = pyimport("proplot");

coord = readdlm(srcdir("GLB-i.txt"),comments=true,comment_char='#')
x = coord[:,1]; y = coord[:,2];

pplt.close(); f,axs = pplt.subplots(nrows=1,aspect=6,axwidth=6,sharey=0);

axs[1].plot(x,y,c="k",lw=0.2)
axs[1].plot([60,270,270,60,60],[-15,-15,20,20,-15],c="r",lw=1)
axs[1].plot([90,165,165,90,90],[-15,-15,20,20,-15],c="b",lw=1)
axs[1].format(xlim=(0,360),ylim=(-30,30))

f.savefig(plotsdir("domain.png"),transparent=false,dpi=200)
