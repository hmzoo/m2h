cd src
haxe m2h.hxml -D HXCPP_M64
cd ..

cp ./build/cpp/Main ./bin/m2h

cp ./bin/m2h ./documents/download

./bin/m2h documents

