chamfer = 0.5;

// Circular cutout for charger
module charger_cutout(
    bin_height, // The total height of the bin, the top of the charger cutout will be flush with this
    base_height, // The height of the base of the bins,
    tray_length,
    charger_height, 
    charger_diameter, 
    plug_width,
    cable_diameter,
    cable_cutout_clearance,
    cable_management_clearance,
    cable_relief_length, 
    cable_relief_diameter
) {
    total_height = bin_height + base_height;
    through_cut_z_offset = -1;
    through_cut_height = total_height - charger_height - through_cut_z_offset;
    
    cable_relief_diameter = cable_relief_diameter + cable_cutout_clearance;
    cable_diameter_with_clearance = cable_diameter + cable_cutout_clearance;
    cable_diameter_with_management_clearance = cable_diameter + cable_management_clearance;

    // The main charger cutout
    translate([0, 0, total_height - charger_height])
    union() {
        cylinder(h = charger_height, d = charger_diameter, center = false, $fn=100);
        
        // Add chamfer at the top of the circular cutout
        translate([0, 0, charger_height - chamfer])
        cylinder(h = chamfer, d1 = charger_diameter, d2 = charger_diameter + 1, center = false, $fn=100);  // 1mm high chamfer, expanding by 2mm
    }

    // Cut through to bottom for pushing the USB cable through
    translate([0, 0, through_cut_z_offset+0.01])
    union() {
        cylinder(h = through_cut_height, d = plug_width, center = false, $fn=50);
        translate([0, -cable_diameter_with_management_clearance/2, 0])
        cube([charger_diameter/2+cable_relief_length, cable_diameter_with_management_clearance, through_cut_height + cable_relief_diameter/2]);
    }


    translate([-0.3, 0, 0])
    hull() {
        // Cutout for the cable relief
        translate([charger_diameter/2, 0, through_cut_height + through_cut_z_offset + cable_relief_diameter/2])
        rotate([0, 90, 0])
        cylinder(d=cable_relief_diameter, h=cable_relief_length, $fn=20);

        // Blend down to the cable routing to avoid sharp bends in the cable
        translate([charger_diameter/2 + cable_relief_length, 0, base_height + cable_diameter_with_management_clearance/2])
        rotate([0, 90, 0])
        cylinder(h = 30, d = cable_diameter_with_management_clearance, $fn=50);
    }

    // Cable routing to the back of the tray
    translate([0, 0, base_height + cable_diameter_with_management_clearance/2])
    rotate([0, 90, 0])
    cylinder(h = tray_length/2, d = cable_diameter_with_management_clearance, $fn=50);

    bottom_cutout_percent=0.90; // We want the main cut through to be smaller than the cable to help hold it in place 
    bottom_cutout_width=bottom_cutout_percent*cable_diameter_with_management_clearance;
    bottom_cutout_height=base_height + bottom_cutout_width/2 - through_cut_z_offset;

    translate([0, -bottom_cutout_width/2, through_cut_z_offset])
    cube([tray_length/2, bottom_cutout_width, bottom_cutout_height]);
}

// module cable_management_cutout(base_height, diameter, length, z_offset) {

    
// }