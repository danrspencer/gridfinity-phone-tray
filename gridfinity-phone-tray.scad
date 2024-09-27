include <gridfinity-rebuilt-openscad/gridfinity-rebuilt-utility.scad>

// ===== PHONE PARAMETERS ===== //

/* [Phone Size] */
// Just the phone cutout so the dimensions can be tested
test_phone_cutout = false;

// Known phone dimensions. It is recommended to do a test print first if using untested or custom phone dimensions
phone_preset = 1; // [0: Custom, 1: iPhone 16 Pro Max, 2: iPhone 16 Pro !UNTESTED!, 3:iPhone 16 Plus !UNTESTED!, 4:iPhone 16 !UNTESTED!]

function phone_presets() = 
    phone_preset == 1 ? [163.0, 77.6, 34.0, 6] : // iPhone 16 Pro Max
    phone_preset == 2 ? [149.6, 71.5, 34.0, 6] : // iPhone 16 Pro
    phone_preset == 3 ? [160.9, 77.8, 34.0, 6] : // iPhone 16 Plus
    phone_preset == 4 ? [147.6, 71.6, 34.0, 6] : // iPhone 16
    [0, 0, 0, 0]; // Custom

// Phone length
custom_phone_length = 163.0;
// Phone width 
custom_phone_width = 77.6;
// Phone corner curve
custom_phone_corner_curve = 34.0;
// Phone corner smoothness (Used to approximate the gentler curves of a phone)
custom_phone_corner_smoothness = 6;

/* [Phone Cutout] */
// Clearance around Phone (per side) - can be used to accomdate a phone case (remember to leave some additional clearance)
phone_clearance = 0.3;
// A cutout area to allow for a camera bump on the back of the phone
phone_cutout_height = 5;
// How tall the chamfered edge is
phone_chamfer_height = 2;
// Chamfer angle (in degrees)
phone_chamfer_angle = 20;

function phone_length() = (phone_preset == 0 ? custom_phone_length : phone_presets()[0]) + 2*phone_clearance;
function phone_width() = (phone_preset == 0 ? custom_phone_width : phone_presets()[1]) + 2*phone_clearance;
function phone_corner_curve() = (phone_preset == 0 ? custom_phone_corner_curve : phone_presets()[2]);
function phone_corner_smoothness() = (phone_preset == 0 ? custom_phone_corner_smoothness : phone_presets()[3]);

// ===== CHARGER PARAMETERS ===== //
/* [Charger Size] */
// Just the charger cutout so the dimensions can be tested
test_charger_cutout = false;
// Known charger dimensions. It is recommended to do a test print first if using untested or custom charger dimensions
charger_preset = 1; // [0: Custom, 1: Apple MagSafe Charger !UNTESTED!, 2: Belkin MagSafe Wireless Charger Pad, 3: Mous Mage MagSafe Charger !UNTESTED!]

function charger_presets() = 
    // Diameter, Depth, Cable Width, Cable Height, Cable Straight Length
    charger_preset == 1 ? [55.5, 4.37, 5, 10.7] : // Apple MagSafe Charger
    charger_preset == 2 ? [58.5, 11.7, 6.5, 11] : // Belkin MagSafe Wireless Charger Pad
    charger_preset == 3 ? [56.8, 5.5, 6.5, 12] : // Mous MagSafe Charger
    [0, 0, 0, 0, 0]; // Custom

// Diameter of the circular cutout in the charger tray
custom_charger_cutout_diameter = 55.5;
// Depth of the circular cutout in the charger tray
custom_charger_cutout_depth = 4.37;
// Width of the cable cutout
custom_cable_cutout_width = 5; //.1
// Height of the cable cutout
custom_cable_cutout_height = 11; //.1

function charger_cutout_diameter() = (charger_preset == 0 ? custom_charger_cutout_diameter : charger_presets()[0])  + 2*charger_cutout_clearance;
function charger_cutout_depth() = (charger_preset == 0 ? custom_charger_cutout_depth : charger_presets()[1]) + charger_cutout_clearance;

function cable_cutout_width() = (charger_preset == 0 ? custom_cable_cutout_width : charger_presets()[2]);
function cable_cutout_height() = (charger_preset == 0 ? custom_cable_cutout_height : charger_presets()[3]);
function cable_cutout_top_offset() = charger_cutout_depth() - cable_cutout_height() - cable_cutout_top_offset;
function cable_cutout_angle() = cable_cutout_angle > 0 ? cable_cutout_angle : atan2(phone_cutout_height, wedge_length());

function wedge_length() = (phone_length() - charger_tray_width)/2;

/* [Charger Tray] */
// Width of the charger tray extrusion
charger_tray_width = 70.0;
// Clearance around the charger cutout
charger_cutout_clearance = 0.7;
// Diameter of the central hole in the charger tray
charger_tray_central_hole_diameter = 15;
// How far to go back straight before angling down - this is likely not needed if printing the cutout on its side as recommended
cable_cutout_straight_length = 0; //.1
// Offset from the top of the charger cutout
cable_cutout_top_offset = 1.5; //.5
// Radius for the rounded corners of the cable cutout
cable_cutout_corner_radius = 2.5; //.5
// Cutout angle (0 to calculate automatically)
cable_cutout_angle = 4.5; //.5

// ===== GRIDFINITY PARAMETERS ===== //

/* [Gridfinity Grid] */
// number of bases along x-axis
gridx = 4; //.5
// number of bases along y-axis
gridy = 2; //.5
// bin height. See bin height information and "gridz_define" below.
gridz = 2; //.1

/* [Gridfinity Height Settings] */
// determine what the variable "gridz" applies to based on your use case
gridz_define = 0; // [0:gridz is the height of bins in units of 7mm increments - Zack's method,1:gridz is the internal height in millimeters, 2:gridz is the overall external height of the bin in millimeters]
// snap gridz height to nearest 7mm increment
enable_zsnap = false;

/* [Gridfinity Base Options] */
// Enable or disable the base plate
base_plate_enabled = true;
// only cut magnet/screw holes at the corners of the bin to save uneccesary print time
only_corners = false;
//Use gridfinity refined hole style. Not compatible with magnet_holes!
refined_holes = false;
// Base will have holes for 6mm Diameter x 2mm high magnets.
magnet_holes = false;
// Base will have holes for M3 screws.
screw_holes = false;
// Magnet holes will have crush ribs to hold the magnet.
crush_ribs = true;
// Magnet/Screw holes will have a phone_chamfer_height to ease insertion.
chamfer_height_holes = true;
// Magnet/Screw holes will be printed so supports are not needed.
printable_hole_top = true;

hole_options = bundle_hole_options(refined_holes, magnet_holes, screw_holes, crush_ribs, chamfer_height_holes, printable_hole_top);

/* [Gridfinity Setup Parameters] */
$fa = 8;
$fs = 0.25; // .01

function style_lip() = 2;
function bin_height() = height(gridz, gridz_define, style_lip(), enable_zsnap);

// ===== MODULES ===== //

// Module to create tapered iPhone shape
module cutout_chamfered_edge(length, width, height, curve, smoothness, angle) {
    top_scale = 1 + 2 * tan(angle) * height / sqrt(length*length + width*width);
    
    scale([top_scale, top_scale, 1])
    translate([0, 0, height])
    mirror([0, 0, 1])
    linear_extrude(height=height, scale=top_scale/top_scale)
    phone_2d_shape(length, width, curve, smoothness);
}

// Module to create 2D iPhone shape
module phone_2d_shape(length, width, curve, smoothness) {
    hull() {
        for (x = [-1, 1], y = [-1, 1]) {
            translate([x * (length/2 - curve), y * (width/2 - curve)])
            superellipse(curve, curve, smoothness);
        }
    }
}

// Module to create superellipse shape
module superellipse(a, b, n) {
    points = [for (t = [0:5:359]) [
        a * pow(abs(cos(t)), 2/n) * sign(cos(t)),
        b * pow(abs(sin(t)), 2/n) * sign(sin(t))
    ]];
    polygon(points);
}

// Modified charger tray module
module charger_tray() {
    charger_tray_height = phone_cutout_height;
    
    difference() {
        union() {
            // Main charger tray body
            translate([0, 0, -(phone_chamfer_height
         + charger_tray_height/2)])
            cube([charger_tray_width, phone_width(), charger_tray_height], center=true);
            
            // Wedge
            translate([charger_tray_width/2, 0, -(phone_chamfer_height
         + charger_tray_height)])
            rotate([90, 0, 0])
                wedge(wedge_length(), phone_width(), charger_tray_height);
        }
        
        // Chamfered edge on the side opposite the wedge
        translate([-charger_tray_width/2+charger_tray_height/2, 0, 0])
        rotate([0, 45, 0])
        translate([-charger_tray_height, 0, 0])
        cube([charger_tray_height * 2, phone_width() + 1, charger_tray_height * 2], center=true);
    }
}

// Corrected wedge module
module wedge(length, width, height) {
    linear_extrude(height = width, center = true)
    polygon([
        [0, height],
        [length, 0],
        [0, 0],
    ]);
}

module rounded_cube(size, curve) {
    curve = min(curve, size.y/2, size.z/2);
    if (curve <= 0) {
            cube(size);
    } else {
        hull() {
            translate([0, curve, curve])
            rotate([0, 90, 0])
            cylinder(r=curve, h=size.x);
            
            translate([0, size.y - curve, curve])
        rotate([0, 90, 0])
            cylinder(r=curve, h=size.x);
        
            translate([0, curve, size.z - curve])
        rotate([0, 90, 0])
            cylinder(r=curve, h=size.x);
        
            translate([0, size.y - curve, size.z - curve])
            rotate([0, 90, 0])
            cylinder(r=curve, h=size.x);
        }
    }
}

if (test_phone_cutout) {
    difference() {
        translate([0, 0, phone_chamfer_height
    /2])
        cube([phone_length()+5, phone_width()+5, phone_chamfer_height
    -0.01], center=true);
        cutout_chamfered_edge(phone_length(), 
            phone_width(), 
            phone_chamfer_height
         + 0.01, 
            phone_corner_curve(), 
            phone_corner_smoothness(),
            phone_chamfer_angle
        );
    }
} else if (test_charger_cutout) {
    difference() {
        translate([-(1+charger_cutout_diameter()/2), -(1+charger_cutout_diameter()/2), -1])
        cube([2+charger_cutout_diameter(), 2+charger_cutout_diameter(), charger_cutout_depth()+1]);
        union() {
            // Circular cutout for charger
            union() {
                cylinder(h = charger_cutout_depth() + 0.01, d = charger_cutout_diameter(), center = false);
                
                // Add chamfer at the top of the circular cutout
                translate([0, 0, charger_cutout_depth() - .5])  // Position the chamfer 1mm below the top
                cylinder(h = .5, d1 = charger_cutout_diameter(), d2 = charger_cutout_diameter() + 1, center = false);  // 1mm high chamfer, expanding by 2mm
            }
            
            // Cylinder cutout through to the top for pushing the charger out
            translate([0, 0, -bin_height()+0.01])
            union() {
                cylinder(h = bin_height(), d = charger_tray_central_hole_diameter, center = false);
                
                // Add chamfer at the top of the cylinder
                translate([0, 0, bin_height() - 1])  // Position the chamfer 1mm below the top
                cylinder(h = 1, d1 = 10, d2 = charger_tray_central_hole_diameter+2, center = false);  // 1mm high chamfer, expanding from 10mm to 12mm diameter
            }
            
            // Rectangular cutout for charging cable
            translate([
                0, 
                -cable_cutout_width()/2, 
                cable_cutout_top_offset()
            ])
            rounded_cube([cable_cutout_straight_length + charger_cutout_diameter()/2, cable_cutout_width(), cable_cutout_height], cable_cutout_corner_radius);
            
            // Angled cutout extending to the edge of the tray
            translate([
                cable_cutout_straight_length - 2 + charger_cutout_diameter()/2,
                -cable_cutout_width()/2,
                cable_cutout_top_offset()
            ])
            rotate([0, cable_cutout_angle(), 0])
            rounded_cube([
                (gridx/2) * 42 - (charger_cutout_diameter()/2 + cable_cutout_straight_length) + 5,
                cable_cutout_width(),
                cable_cutout_height
            ], cable_cutout_corner_radius);
        }
    }
} else {
    difference() {
        union() {
            gridfinityInit(gridx, gridy, bin_height(), 0, sl=style_lip()) {
                cut_move(x=0, y=0, w=gridx, h=gridy) {
                    difference() {
                        union() {
                            // Top Chamfer
                            translate([0, 0, -phone_chamfer_height
                        ])
                            cutout_chamfered_edge(phone_length(), 
                                                phone_width(), 
                                                phone_chamfer_height
                                             + 0.01, 
                                                phone_corner_curve(), 
                                                phone_corner_smoothness(),
                                                phone_chamfer_angle
                                            );
                            
                            // TODO - Just reuse the chamfer logic here
                            // we might need to chop the existing shape below in half for the other end of the tray
                            // Cutout
                            translate([0, 0, -phone_chamfer_height
                         - phone_cutout_height + 0.01])
                            linear_extrude(height = phone_cutout_height)
                            phone_2d_shape(phone_length(), 
                                            phone_width(), 
                                            phone_corner_curve(), 
                                            phone_corner_smoothness());
                        }
                        charger_tray();
                    }   
                }
            }
            if (base_plate_enabled) {
                gridfinityBase(gridx, gridy, l_grid, 0, 0, hole_options, only_corners=only_corners);
            }
        }
        translate([
            0,
            0,
            bin_height()+4.75-phone_chamfer_height
        -charger_cutout_depth()
        ])
        union() {
            // Circular cutout for charger
            union() {
                cylinder(h = charger_cutout_depth() + 0.01, d = charger_cutout_diameter(), center = false);
                
                // Add chamfer at the top of the circular cutout
                translate([0, 0, charger_cutout_depth() - .5])  // Position the chamfer 1mm below the top
                cylinder(h = .5, d1 = charger_cutout_diameter(), d2 = charger_cutout_diameter() + 1, center = false);  // 1mm high chamfer, expanding by 2mm
            }
            
            // Cylinder cutout through to the top for pushing the charger out
            translate([0, 0, -bin_height()+0.01])
            union() {
                cylinder(h = bin_height(), d = charger_tray_central_hole_diameter, center = false);
                
                // Add chamfer at the top of the cylinder
                translate([0, 0, bin_height() - 1])  // Position the chamfer 1mm below the top
                cylinder(h = 1, d1 = charger_tray_central_hole_diameter, d2 = charger_tray_central_hole_diameter+2, center = false);  // 1mm high chamfer, expanding from 10mm to 12mm diameter
            }
            
            // Rectangular cutout for charging cable
            translate([
                0, 
                -cable_cutout_width()/2, 
                -bin_height()+0.1
            ])
            cube([cable_cutout_straight_length + charger_cutout_diameter()/2, cable_cutout_width(), bin_height()]);
            
            // Angled cutout extending to the edge of the tray
            translate([
                cable_cutout_straight_length - 2 + charger_cutout_diameter()/2,
                -cable_cutout_width()/2,
                cable_cutout_top_offset()
            ])
            rotate([0, cable_cutout_angle(), 0])
            rounded_cube([
                (gridx/2) * 42 - (charger_cutout_diameter()/2 + cable_cutout_straight_length) + 5,
                cable_cutout_width(),
                cable_cutout_height()
            ], cable_cutout_corner_radius);
        }
    }
}