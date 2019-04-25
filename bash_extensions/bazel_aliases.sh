alias bb="bazel build -c opt --config cuda --jobs $(nproc) $1"
alias bb_basics="bb //onboard/comms:registry_runner //onboard/nuro_viewer:nuro_viewer_offboard //playback/playback_core:playback //onboard/comms:topic_echo"
alias bt="bazel test -c opt --config cuda --jobs $(nproc) $1"
