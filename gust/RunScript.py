#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import subprocess

def run_lotus(keys,values):
    "Write a lotus.f90 file and run in a folder using a set of keys and values"
    changes = dict(zip(keys,values))                         # make the dictionary
    write_lotus(changes)                                     # make the lotus file
    folder = '_'.join([i+'_'+j for i,j in changes.items()])  # name the folder
    subprocess.check_call('runLotus 0 '+folder, shell=True)  # run the simulation

def write_lotus(dic):
    "Write the lotus file by replacing from the template"
    f1 = open('template.f90','r')
    f2 = open('lotus.f90','w')
    for line in f1:
        f2.write(replace_all(line,dic))
    f1.close()
    f2.close()
    return

def replace_all(text, dic):
    "Replace all dictionary keys in text with their value"
    for i, j in dic.items():
        text = text.replace(i, j)
    return text

# Set up the keys and values
keys = ['DELAY_VAL','KINEMATIC_FLAG']
delay_vals = range(5)
kinematic_vals = range(2)

# Sweep through the simulations
for d in delay_vals:
    for k in kinematic_vals:
        run_lotus(keys,values=[str(d),str(k)])