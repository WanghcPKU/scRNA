import os, sys
os.getcwd()
#os.chdir("/lustre/user/taowlab/wanghc/work/lvwc/ytgs/zuhui/20240527")
os.listdir(os.getcwd()) 

import loompy as lp;
import numpy as np;
import scanpy as sc;
x=sc.read_csv("./cm.csv");
row_attrs = {"Gene": np.array(x.var_names),};
col_attrs = {"CellID": np.array(x.obs_names)};
lp.create("./cm.loom",x.X.transpose(),row_attrs,col_attrs);
