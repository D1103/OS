x=1
while [ $x -lt 1000 ]
do
touch $x.txt
x=$(( $x + 1 ))
done
ls -a
