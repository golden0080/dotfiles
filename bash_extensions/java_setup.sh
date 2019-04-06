function jversion() {
    export JAVA_HOME=$(/usr/libexec/java_home -v $1)
    echo "Switched to JAVA v$1"
}
