export GOVERSION=1.10
export GOROOT="$HOME/go-install/$GOVERSION"
export PATH="$GOROOT/bin/:$PATH"

export GOPATH="$HOME/go-projects/$GOVERSION"
export PATH="$GOPATH/bin/:$PATH"
function gopro() {
    cd $GOPATH/src/$1
}
function tuv() {
    cd $GOPATH/src/turingvideo.com/$1
}
