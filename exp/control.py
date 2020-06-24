import os

import numpy as np

import f90nml

from isca import IscaCodeBase, DiagTable, Experiment, Namelist, GFDL_BASE, GFDL_DATA

NCORES = 32
RESOLUTION = 'T85', 30

base_dir = os.path.dirname(os.path.realpath(__file__))
cb = IscaCodeBase.from_directory(GFDL_BASE); cb.compile()

exp = Experiment('control', codebase=cb)

diag = DiagTable()
diag.add_file('atmos_hourly', 1, 'hours', time_units='hours')
diag.add_field('dynamics', 'ps', time_avg=True)
diag.add_field('dynamics', 'bk')
diag.add_field('dynamics', 'pk')
# diag.add_field('dynamics', 'ucomp', time_avg=True)
# diag.add_field('dynamics', 'vcomp', time_avg=True)
# diag.add_field('dynamics', 'omega', time_avg=True)
diag.add_field('dynamics', 'temp', time_avg=True)
diag.add_field('dynamics', 'sphum', time_avg=True)
diag.add_field('atmosphere', 't_surf', time_avg=True)
diag.add_field('atmosphere', 'sphum_2m', time_avg=True)
diag.add_field('atmosphere', 'precipitation', time_avg=True)
diag.add_field('atmosphere', 'convection_rain', time_avg=True)
diag.add_field('atmosphere', 'condensation_rain', time_avg=True)
diag.add_field('atmosphere', 'precipitation', time_avg=True)

exp.diag_table = diag
exp.clear_rundir()
exp.namelist = f90nml.read('namelist.nml')
exp.set_resolution(*RESOLUTION)

exp.update_namelist({
    'astronomy_nml': {
        'obliq' : 0.0
    }
})

#Lets do a run!
if __name__=="__main__":
    exp.run(1, use_restart=False, num_cores=NCORES)
    for i in range(2,121):
        exp.run(i, num_cores=NCORES)
