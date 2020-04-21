#!/bin/bash
##run Lefse tool
run_lefse.py InputLEfSe lefse_test.res 
plot_res.py lefse_test.res C_lefse_test.lda.pdf --format pdf --dpi 150 --width 16
