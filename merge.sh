#!/bin/bash

rm final.pdb
touch final.pdb
head -364 nano.pdb > final.pdb 
tail -136 mem.pdb  | head -134 >> final.pdb
tail -136 mem1.pdb | head -134 >> final.pdb
tail -136 mem2.pdb | head -134 >> final.pdb
echo "TER" >> final.pdb
echo "ENDMDL" >> final.pdb

