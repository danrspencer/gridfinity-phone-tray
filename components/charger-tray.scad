
// Charger tray with wedge
module charger_tray(height, width, tray_length, wedge_length, chamfer) {
    difference() {
        // Main charger tray body
        cube([tray_length, width, height], center=true);
        // Chamfered edge on the side opposite the wedge
        translate([-tray_length/2, 0, height/2])
        rotate([0, 45, 0])
        cube([chamfer, width, chamfer], center=true);
    }
    
    // Wedge
    translate([tray_length/2, 0, -height/2])
    rotate([90, 0, 0])
    wedge(wedge_length, width, height, chamfer);
}

// Wedge for the charger tray
module wedge(length, width, height, chamfer) {
    linear_extrude(height = width, center = true)
    polygon([
        [0, height],
        [length, 0],
        [0, 0],
    ]);

    wedge_angle = atan(length / height);
    wedge_hypotenuse = sqrt(length * length + height * height);

    // Edge blends
    difference() {
        union() {
            difference() {
            translate([length, -chamfer, width/2])
            rotate([0, 45, wedge_angle])
            cube([chamfer, wedge_hypotenuse, chamfer]);
            translate([length, -chamfer, width/2])
            rotate([0, 0, wedge_angle])
                cube([chamfer*2, wedge_hypotenuse+2, chamfer]);
            }

            difference() {
            translate([length, -chamfer, -width/2])
            rotate([0, 45, wedge_angle])
            cube([chamfer, wedge_hypotenuse, chamfer]);
            translate([length, -chamfer, -width/2-chamfer])
            rotate([0, 0, wedge_angle])
                cube([chamfer*2, wedge_hypotenuse+2, chamfer]);
            }

            difference() {
            translate([length, 0, -width/2])
            rotate([90, 0, wedge_angle-45])
            cube([chamfer, width, chamfer]);
            translate([length+chamfer/2, chamfer, -width/2])
            rotate([90, 0, 0])
            cube([chamfer, width, chamfer*2]);
            }
        }
    translate([0, height+chamfer, -width/2])
    rotate([90, 0, 0])
    cube([chamfer*2, width, chamfer]);
}
}

charger_tray(10, 50, 30, 30, 2);
