using DrWatson
@quickactivate "DiConv"

using ClimateERA

init,eroot = erastartup(aID=1,dID=1,path="/n/kuangdss01/lab/");
eraanalysis(init,eroot,modID="msfc",parID="t_sst",regID="TRP");
# eraanalysis(init,eroot,modID="msfc",parID="t_sfc",regID="TRP");

eracompile(init,eroot,modID="msfc",parID="t_sst",regID="TRP");
eracompile(init,eroot,modID="msfc",parID="t_sfc",regID="TRP");
