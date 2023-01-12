mol load pdb pcout.pdb
set sel1 [atomselect top "all"]
set com [measure center $sel1 weight mass]
set matrix [transaxis y 90]
$sel1 moveby [vecscale -1.0 $com]
$sel1 move $matrix
$sel1 moveby {-140 0 }
$sel1 set resid 8
$sel1 writepdb mem.pdb
exit
