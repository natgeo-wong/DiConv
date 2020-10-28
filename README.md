# **<div align="center">DiConv</div>**

This repository contains the analysis scripts and output for the **DiConv** project, written in Julia.  This is a project repository containing initial test runs that led to a spinoff project in [TropicalRCE](https://github.com/natgeo-wong/TropicalRCE).  DiConv itself has evolved into a separate project [DACA](https://github.com/natgeo-wong/DACA), and therefore this repository will no longer be actively maintained after a undetermined period of time.

**Created/Mantained By:** Nathanael Wong (nathanaelwong@fas.harvard.edu)\
**Other Collaborators:** Zhiming Kuang (kuang@fas.harvard.edu)

## Current Status

**SAM Model**
* [x] Build SAM model and run basic test cases
* [x] Write scripts (maybe a package?) to analyse test output and expand to other variables
* [x] Apply Weak Temperature Gradient (WTG) and/or damp Gravity Waves to SAM

## Installation

	To (locally) reproduce this project, do the following:

	0. Download this code base. Notice that raw data are typically not included in the
	   git-history and may need to be downloaded independently.
	1. Open a Julia console and do:
	   ```
	   julia> ] activate .
	    Activating environment at `~/Projects/DiConv/Project.toml`

	   (DiConv) pkg> instantiate
	   (DiConv) pkg> add GeoRegions#master SAMTools#master
	   ```

	This will install all necessary packages for you to be able to run the scripts and
	everything should work out of the box.

	*(Note: You need to install the #master versions of GeoRegions.jl and SAMTools.jl as of now.)*

## **Other Acknowledgements**
> Project Repository Template generated using [DrWatson.jl](https://github.com/JuliaDynamics/DrWatson.jl) created by George Datseris.\
> Work from this project was funded by xxx
