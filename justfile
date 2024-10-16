build:
    rm -rf out
    mkdir -p out
    sed 's/^include <gridfinity-rebuilt-openscad\/gridfinity-rebuilt-utility.scad>/\/\/include <gridfinity-rebuilt-openscad\/gridfinity-rebuilt-utility.scad>/' gridfinity-phone-tray.scad > out/gridfinity-phone-tray-base.scad
    cp -r components out/components
    cp -r gridfinity-rebuilt-openscad out/gridfinity-rebuilt-openscad
    python3 combine.py out/gridfinity-phone-tray-base.scad > out/gridfinity-phone-tray.scad
    sed -i '' 's/^\/\/include <gridfinity-rebuilt-openscad\/gridfinity-rebuilt-utility.scad>/include <gridfinity-rebuilt-openscad\/gridfinity-rebuilt-utility.scad>/' out/gridfinity-phone-tray.scad
    rm -rf out/components out/gridfinity-phone-tray-base.scad