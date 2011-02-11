#!/bin/bash
export LANG=C

# show shared memory
pgrep -f ora_pmon|xargs -n1 pmap -q|\
	perl -lane 'if($F[2] =~ /...s./){chop($F[1]);$s+=$F[1]};END{print "shared memory: ${s}KB"}'

# show text
pgrep -f ora_pmon|xargs -n1 pmap -q|\
	perl -lane 'if($F[2] eq q/r-x--/){chop($F[1]);$s+=$F[1]};END{print "text: ${s}KB"}'

# show data and stack
echo 'data and stack:'
echo 'PID  NAME          KB'
echo '---- ------------- ------'
pgrep -f '^ora_|^oracle'|while read LINE
do
echo ${LINE} `cat /proc/${LINE}/cmdline` `pmap -q ${LINE}|\
	perl -lane 'if($F[2] eq q/rwx--/){chop($F[1]);$s+=$F[1]}END{print "$s"}'`
done
