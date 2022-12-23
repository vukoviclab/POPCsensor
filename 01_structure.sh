#!/bin/bash
cnt_file=$1
head_file=`head -1 $cnt_file`
sliced_file=($head_file)
nano_length=${sliced_file[3]}
x_box=${sliced_file[1]}
y_box=${sliced_file[2]}
x_box=`python -c "print($x_box)"`
y_box=`python -c "print($y_box)"`
starting_point=$3
distance_between_lipids=`python -c "print($nano_length/$2)"`
vmd -dispdev text -e 02-align-cnt.tcl
sed -e '$ d' align.pdb > not-rotate.pdb
for i in $(seq 1 $2)
do
	sed -i '7,10d' rotate-pc.tcl
	if [[ $i -eq 1 ]]
	then
		tmp=`python -c "print($distance_between_lipids/2+$3)"`
		echo "\$sel1 moveby {$4 0 $tmp}
\$sel1 set resid $i 
\$sel1 writepdb mem.pdb
exit" >> rotate-pc.tcl
vmd -dispdev text -e rotate-pc.tcl
sed -e '1d;$ d' mem.pdb >> not-rotate.pdb
rm mem.pdb
	else
		tmp=`python -c "print(($distance_between_lipids/2)+($i-1)*$distance_between_lipids+$3)"`
		echo "\$sel1 moveby {$4 0 $tmp}
\$sel1 set resid $i
\$sel1 writepdb mem.pdb
exit" >> rotate-pc.tcl
vmd -dispdev text -e rotate-pc.tcl
sed -e '1d;$ d' mem.pdb >> not-rotate.pdb
rm mem.pdb
	fi
done
echo 'END' >> not-rotate.pdb

sed -e '$ d' not-rotate.pdb > final.pdb
counter=1
for j in {30..330..30}
do
	sed -i '5d' rotate.tcl
	sed -i "5 i set matrix [transaxis z $j]" rotate.tcl
	vmd -dispdev text -e rotate.tcl
	
	echo "mol load pdb tmp-rotated.pdb
set sel1 [atomselect top \"resid 1 and resname POPC\"]
set sel2 [atomselect top \"resid 2 and resname POPC\"]
set sel3 [atomselect top \"resid 3 and resname POPC\"]
set sel4 [atomselect top \"resid 4 and resname POPC\"]
set sel5 [atomselect top \"resid 5 and resname POPC\"]
set sel6 [atomselect top \"resid 6 and resname POPC\"]
set sel7 [atomselect top \"resid 7 and resname POPC\"]
set sel8 [atomselect top \"resid 8 and resname POPC\"]
\$sel1 set resid $((counter + 8))
\$sel2 set resid $((counter + 9))
\$sel3 set resid $((counter + 10))
\$sel4 set resid $((counter + 11))
\$sel5 set resid $((counter + 12))
\$sel6 set resid $((counter + 13))
\$sel7 set resid $((counter + 14))
\$sel8 set resid $((counter + 15))
\$sel1 writepdb tmp-rot-1.pdb
\$sel2 writepdb tmp-rot-2.pdb
\$sel3 writepdb tmp-rot-3.pdb
\$sel4 writepdb tmp-rot-4.pdb
\$sel5 writepdb tmp-rot-5.pdb
\$sel6 writepdb tmp-rot-6.pdb
\$sel7 writepdb tmp-rot-7.pdb
\$sel8 writepdb tmp-rot-8.pdb

exit" > change-resid.tcl
	counter=$((counter + 8))
	vmd -dispdev text -e change-resid.tcl
	sed -e '1d;$ d' tmp-rot-1.pdb >> final.pdb
	sed -e '1d;$ d' tmp-rot-2.pdb >> final.pdb
	sed -e '1d;$ d' tmp-rot-3.pdb >> final.pdb
	sed -e '1d;$ d' tmp-rot-4.pdb >> final.pdb
	sed -e '1d;$ d' tmp-rot-5.pdb >> final.pdb
	sed -e '1d;$ d' tmp-rot-6.pdb >> final.pdb
	sed -e '1d;$ d' tmp-rot-7.pdb >> final.pdb
	sed -e '1d;$ d' tmp-rot-8.pdb >> final.pdb
	rm tmp-rot*.pdb
done
echo 'END' >> final.pdb






