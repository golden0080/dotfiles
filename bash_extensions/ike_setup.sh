export PHOME=$HOME/projects/IkeAV
alias phome="cd $PHOME"
alias truck_viewer="sudo ./bazel-bin/onboard/nuro_viewer/nuro_viewer --remote_nuro_viewer --params_profile onboard/config/profiles/base/truck_v0_sensors.pbtxt --calib_profile onboard/config/calibration/truck101_v0.pbtxt --registry_ip 172.23.11.41 --fake_robot_time_from_topic=clock --fake_robot_time"
alias ike_python="pushd $PHOME && bb //ike_python:ike_python && ./bazel-bin/ike_python/ike_python"

function bzrun() {
    $PHOME/bazel-bin/$1
}

if [ -f $HOME/.ike_env ]; then
    . $HOME/.ike_env
fi
