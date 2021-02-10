#! /bin/bash
## rsync local dir to remote dir: bash ./rsyncWhat up -y
## fetch remote dir to local: bash ./rsyncWhat down -y
## Remote servers and dirs can be stored in ./.remotesync, of which only the last line is applied.

work_local=`dirname "$(realpath "${BASH_SOURCE[0]}")"`
work_remote="my-server:backup_dir/$(basename "$work_local")"

if [ -d "$work_local/.remotesync" ]; then
	work_remote="$(realpath "$work_local/.remotesync")"
elif [ -f "$work_local/.remotesync" ] ; then
	work_remote="$(tail -n 1 $work_local/.remotesync)"
fi

if [ -d "$work_local/.localsync" ] ; then
	work_local="$(realpath "$work_local/.localsync")"
	work_remote="$(dirname "$work_remote")/$(basename "$work_local")"
elif [ -f "$work_local/.localsync" ] ; then
	work_local="$(tail -n 1 "$work_local/.localsync")"
	work_remote="$(dirname "$work_remote")/$(basename "$work_local")"
fi

updown="unknown"
confirm1ce=1
exld=" --exclude '_region_.*' "

for o in $@ ; do
	if [ $o == up ] ; then
		updown=up
	elif [ $o == down ] ; then
		updown=down
	elif [ $o == -y ] ; then
		confirm1ce=0
	fi
done

function doconfirm {
	echo $1
	if [ $confirm1ce == 1 ] ; then
		read -p "OK?   "
	fi
}



cmd="echo 'I will do nothing...'"
if [ $updown == 'down' ] ; then
    cmd="rsync -avtu $exld \"$work_remote/\" \"${work_local%%/}\""
elif [  $updown  == 'up' ] ; then
    cmd="rsync -avtu $exld \"$work_local/\" \"${work_remote%%/}\""
fi
   
    
doconfirm "$cmd"
sh -c "$cmd"

    
date
