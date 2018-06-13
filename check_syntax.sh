#!/bin/bash

clear

export PATH=$PATH:/home/tpecar/faks/1semester/dn/orodja/ise14.7/14.7/ISE_DS/ISE/bin/lin64

vhpcomp -work isim_temp -intstyle ise -prj ./SeminarDN/TopModule_stx_beh.prj -v 2
