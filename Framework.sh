#/bin/sh

cd KKView

rm -rf build

if [ $1 ]
then

target=$1

else

target=Release

fi


xcodebuild -configuration $target
xcodebuild -sdk iphonesimulator9.3 -configuration $target
cp -a build/$target-iphoneos build/$target
lipo -create build/$target-iphoneos/KKView.framework/KKView build/$target-iphonesimulator/KKView.framework/KKView -output build/$target/KKView.framework/KKView

cp -r build/$target/KKView.framework ../KKView.framework

rm -rf build

cd ..



