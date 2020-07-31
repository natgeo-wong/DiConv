using DrWatson
@quickactivate "DiConv"
using ClimateSatellite

ddir = "/n/kuangdss01/lab/"

clisatcompile("gpmimerg",varname="prcp_rate",region="TRP",path=ddir,trange=[2001,2018])
clisatcompile("gpmimerg",varname="prcp_rate",region="SEA",path=ddir,trange=[2001,2018])
clisatcompile("gpmimerg",varname="prcp_rate",region="SMT",path=ddir,trange=[2001,2018])
