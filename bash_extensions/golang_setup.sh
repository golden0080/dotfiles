# Go Version
export GOVERSION=1.10

export GOROOT="$HOME/go-install/$GOVERSION"
export GOPATH="$HOME/go-projects/$GOVERSION"

if [[ ! -d $GOROOT ]] || [[ ! -d $GOPATH ]]; then
    unset GOVERSION
    unset GOROOT
    unset GOPATH
    return
fi

export PATH="$GOROOT/bin/:$GOPATH/bin/:$PATH"

function gopro() {
    cd $GOPATH/src/$1
}

function gocov () {
    package_name=$1
    out_file=${2:-cov.out}
    echo "Coverage for" $package_name $out_file
    go test ./$package_name -coverprofile=$out_file && go tool cover -html=$out_file
}
