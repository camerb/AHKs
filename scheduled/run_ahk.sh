
path="/home/user/Dropbox/AHKs/scheduled/"
file="/asap.ahk"
compy="PHOSPHORUS"
compy="`tail target_compy.txt`"
echo "Sending to $compy for execution"

source="$path$file"
dest="$path$compy$file"

cp $source $dest
