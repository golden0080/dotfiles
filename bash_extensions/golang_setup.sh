gcov () {
    package_name=$1
    out_file=${2:-cov.out}
    echo "Coverage for" $package_name $out_file
    go test ./$package_name -coverprofile=$out_file && go tool cover -html=$out_file
}
