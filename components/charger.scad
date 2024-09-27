
chamfer = 1;

// Charger tray with wedge
module charger_tray(height, width, tray_length, wedge_length) {
    difference() {
        union() {
            // Main charger tray body
            cube([tray_length, width, height], center=true);
            
            // Wedge
            translate([tray_length/2, 0, -height/2])
            rotate([90, 0, 0])
            wedge(wedge_length, width, height);
        }
        
        // Chamfered edge on the side opposite the wedge
        translate([-tray_length/2, 0, height/2])
        rotate([0, 45, 0])
        cube([chamfer, width, chamfer], center=true);
    }
}

// Wedge for the charger tray
module wedge(length, width, height) {
    linear_extrude(height = width, center = true)
    polygon([
        [0, height],
        [length, 0],
        [0, 0],
    ]);
}

charger_tray(10, 50, 50, 50);