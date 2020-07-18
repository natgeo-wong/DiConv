using DrWatson
@quickactivate "DiConv"

using ClimateERA

init,eroot = erastartup(aID=1,dID=1,path="/n/kuangdss01/lab/");
eradownload(init,eroot,modID="msfc",parID="t_sst",regID="TRP");
# eradownload(init,eroot,modID="msfc",parID="t_sfc",regID="TRP");
