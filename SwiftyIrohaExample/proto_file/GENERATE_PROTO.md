```
    $export GOPATH=/Users/username/go
    $export PATH=$GOPATH/bin:$PATH
    $cd path/to/proto/files
    $protoc --swift_out=. --swiftgrpc_out=. *.proto
```
