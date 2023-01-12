set amol [mol load psf cnt-65.psf pdb cnt-65.pdb]
set a [atomselect $amol all]
$a moveby [vecinvert [measure center $a weight mass]]
#$rna writepdb rna_TEMP.pdb
#set vest [atomselect $kcsamol "protein and resid 97 to 106"]
#$kcsa moveby [vecinvert [measure center $vest weight mass]]
#display resetview
#$a move [transaxis z 40 deg]
#$a move [transaxis x 35 deg]
$a writepdb a_TEMP.pdb
mol delete all
package require psfgen
resetpsf
readpsf cnt-65.psf  
coordpdb a_TEMP.pdb
# OUTPUT File names
writepsf align.psf
writepdb align.pdb
file delete a_TEMP.pdb
exit


