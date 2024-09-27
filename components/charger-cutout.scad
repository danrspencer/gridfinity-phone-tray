

// Circular cutout for charger
module charger_cutout(charger_height, charger_diameter, plug_width, bin_height, cable_diameter, cable_relief_length, cable_relief_diameter) {
    union() {
        cylinder(h = charger_height + 0.01, d = charger_diameter, center = false);
        
        // Add chamfer at the top of the circular cutout
        translate([0, 0, charger_height - .5])  // Position the chamfer 1mm below the top
        cylinder(h = .5, d1 = charger_diameter, d2 = charger_diameter + 1, center = false);  // 1mm high chamfer, expanding by 2mm
    }

    // Cylinder cutout through to the top for pushing the charger out
    translate([0, 0, -bin_height+0.01])
    union() {
        cylinder(h = bin_height, d = plug_width, center = false);
        
        // Add chamfer at the top of the cylinder
        translate([0, 0, bin_height - 1])  // Position the chamfer 1mm below the top
        cylinder(h = 1, d1 = plug_width, d2 = plug_width+2, center = false);  // 1mm high chamfer, expanding from 10mm to 12mm diameter
    }

    // Rectangular cutout for charging cable
    translate([0, -cable_diameter/2, -bin_height+0.1])
    cube([cable_relief_length + charger_diameter/2, cable_diameter, bin_height]);

    // Underside scoop to ease cable bending
    scoop_size = 3;
    translate([cable_relief_length + charger_diameter/2, -cable_diameter/2, -bin_height+0.1])
    difference() {
        cube([scoop_size, cable_diameter, scoop_size]);
        translate([scoop_size, cable_diameter/2, scoop_size])
        rotate([0, 90, 90])
        cylinder(r=scoop_size, h=cable_diameter+0.01, center=true);
    }

    // Angled cutout extending to the edge of the tray
    translate([-1+charger_diameter/2,0,0])
    union() {
        difference() {
            rotate([0, 90, 0])
            cylinder(d=cable_relief_diameter, h=cable_relief_length);
            translate([-0.01, -cable_relief_diameter/2, -cable_relief_diameter/2])
            cube([cable_relief_length, cable_relief_diameter,  cable_relief_diameter/2]);
        }
        translate([cable_relief_length, 0, 0])
        sphere(d=cable_relief_diameter);
    }
}

// charger_cutout(10, 50, 10, 20, 3, 20, 5);