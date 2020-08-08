using DrWatson
@quickactivate "DiConv"
using SAMTools

include(srcdir("resort.jl"))

resortdiconv("wtgN-diurnalN","fixedSST-temp303",pdir=datadir(),fname="RCE")
resortdiconv("wtgN-diurnalN","fixedSST-temp305",pdir=datadir(),fname="RCE")
resortdiconv("wtgN-diurnalY","fixedSST-temp303",pdir=datadir(),fname="RCE")
resortdiconv("wtgN-diurnalY","fixedSST-temp305",pdir=datadir(),fname="RCE")
resortdiconv("wtgN-diurnalY","dynamicSST-slab0.2",pdir=datadir(),fname="RCE",dosst=true)
resortdiconv("wtgN-diurnalY","dynamicSST-slab0.5",pdir=datadir(),fname="RCE",dosst=true)
resortdiconv("wtgN-diurnalY","dynamicSST-slab01",pdir=datadir(),fname="RCE",dosst=true)
resortdiconv("wtgN-diurnalY","dynamicSST-slab02",pdir=datadir(),fname="RCE",dosst=true)

resortdiconv("wtgY-diurnalN","fixedSST-temp303",pdir=datadir(),fname="RCE")
resortdiconv("wtgY-diurnalN","fixedSST-temp305",pdir=datadir(),fname="RCE")
resortdiconv("wtgY-diurnalY","fixedSST-temp303",pdir=datadir(),fname="RCE")
resortdiconv("wtgY-diurnalY","fixedSST-temp305",pdir=datadir(),fname="RCE")
resortdiconv("wtgY-diurnalY","dynamicSST-slab0.2",pdir=datadir(),fname="RCE",dosst=true)
resortdiconv("wtgY-diurnalY","dynamicSST-slab0.5",pdir=datadir(),fname="RCE",dosst=true)
resortdiconv("wtgY-diurnalY","dynamicSST-slab01",pdir=datadir(),fname="RCE",dosst=true)
resortdiconv("wtgY-diurnalY","dynamicSST-slab02",pdir=datadir(),fname="RCE",dosst=true)
