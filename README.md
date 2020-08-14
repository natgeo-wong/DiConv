# **<div align="center">DiConv</div>**

This repository contains the analysis scripts and output for the **DiConv** project, which aims to investigate how the diurnal cycle of convection interacts with moisture and rainfall.

**Created/Mantained By:** Nathanael Wong (nathanaelwong@fas.harvard.edu)\
**Other Collaborators:** Zhiming Kuang (kuang@fas.harvard.edu)

> Introductory Text Here.

## Current Status

**SAM Model**
* [x] Build SAM model and run basic test cases
* [x] Write scripts (maybe a package?) to analyse test output and expand to other variables
* [x] Apply Weak Temperature Gradient (WTG) and/or damp Gravity Waves to SAM
* [ ] Run simulations w/ moisture flux at various levels

**Experiments**
* [x] **Control (CON):** No diurnal cycle of heating, take yearly mean
* [x] **Diurnal (DIF):** Impose a diurnal cycle of heating on the domain
	* [x] Vary strength of diurnal cycle --> done by changing slab depth of dynamic ocean
* [ ] **Moisture (MOIST):** Impose a source/flux of moisture into the domain
	* [ ] Vary strength of moisture source and level of input

## Project Setup

In order to obtain the relevant data, please follow the instructions listed below:

### 1) Required Julia Dependencies

The entire codebase of this project (except for the SAM model) is written in Julia.  If the data files are downloaded, you should be able to produce my results in their entirety.  The following are the most important Julia packages that were used in this project:
* NetCDF Data Handling: `NCDatasets.jl`

In order to reproduce the results, first you have to clone the repository, and instantiate the project environment in the Julia REPL in order to install the required packages:
```
git clone https://github.com/natgeo-wong/DiConv.git
] activate .
instantiate
```

## **Other Acknowledgements**
> Project Repository Template generated using [DrWatson.jl](https://github.com/JuliaDynamics/DrWatson.jl) created by George Datseris.\
> Work from this project was funded by xxx
