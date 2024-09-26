include <gridfinity-rebuilt-openscad/gridfinity-rebuilt-utility.scad>

/* [Dimensions] */
// Phone length
phone_length = 163.0;
// Phone width 
phone_width = 77.6;
// Phone corner radius
phone_corner_radius = 34.0;
// Phone corner smoothness (higher = smoother, but more complex)
phone_corner_smoothness = 6;
// Clearance around Phone (per side)
phone_clearance = 0.5;

function phone_length_with_clearance() = phone_length + 2*phone_clearance;
function phone_width_with_clearance() = phone_width + 2*phone_clearance;
function phone_corner_radius_with_clearance() = phone_corner_radius + phone_clearance;

/* [Cutout] */
// A cutout area to allow for a camera bump on the back of the phone
cutout_height = 5;
// How tall the chamfered edge is
chamfer_height = 2;
// Chamfer angle (in degrees)
chamfer_angle = 20;

/* [Charger Tray] */
// Width of the charger tray extrusion
charger_tray_width = 70.0;
// Diameter of the circular cutout in the charger tray
charger_cutout_diameter = 58.5;
// Depth of the circular cutout in the charger tray
charger_cutout_depth = 11.7;
// Clearance around the charger cutout
charger_cutout_clearance = 0.3;

function charger_cutout_diameter_with_clearance() = charger_cutout_diameter + 2*charger_cutout_clearance;
function charger_cutout_depth_with_clearance() = charger_cutout_depth + charger_cutout_clearance;
function wedge_length() = (phone_length_with_clearance() - charger_tray_width)/2;

/* [Cable Cutout] */
// Width of the cable cutout
cable_cutout_width = 15;
// Height of the cable cutout
cable_cutout_height = 8;
// Length of the cable cutout
cable_cutout_length = 30; // Renamed from cable_cutout_depth
// Offset from the bottom of the charger cutout
cable_cutout_bottom_offset = 1.0; // New parameter

function cable_cutout_top_offset() = chamfer_height - charger_cutout_clearance*2 + cable_cutout_top_offset;

function style_lip() = 2;
function bin_height() = height(gridz, gridz_define, style_lip(), enable_zsnap);
// function tray_top_z() = includingFixedHeights(bin_height()) + 0.1;
// function tray_bottom_z() = tray_top_z() - chamfer_height;

/* [Gridfinity Grid Settings] */
// number of bases along x-axis
gridx = 4; //.5
// number of bases along y-axis
gridy = 2; //.5
// bin height. See bin height information and "gridz_define" below.
gridz = 3; //.1

/* [Gridfinity Height Settings] */
// determine what the variable "gridz" applies to based on your use case
gridz_define = 0; // [0:gridz is the height of bins in units of 7mm increments - Zack's method,1:gridz is the internal height in millimeters, 2:gridz is the overall external height of the bin in millimeters]
// snap gridz height to nearest 7mm increment
enable_zsnap = false;

/* [Gridfinity Base Hole Options] */
// only cut magnet/screw holes at the corners of the bin to save uneccesary print time
only_corners = false;
//Use gridfinity refined hole style. Not compatible with magnet_holes!
refined_holes = true;
// Base will have holes for 6mm Diameter x 2mm high magnets.
magnet_holes = false;
// Base will have holes for M3 screws.
screw_holes = false;
// Magnet holes will have crush ribs to hold the magnet.
crush_ribs = true;
// Magnet/Screw holes will have a chamfer_height to ease insertion.
chamfer_height_holes = true;
// Magnet/Screw holes will be printed so supports are not needed.
printable_hole_top = true;

hole_options = bundle_hole_options(refined_holes, magnet_holes, screw_holes, crush_ribs, chamfer_height_holes, printable_hole_top);

/* [Gridfinity Setup Parameters] */
$fa = 8;
$fs = 0.25; // .01

// Module to create tapered iPhone shape
module cutout_chamfered_edge(length, width, height, radius, smoothness, angle) {
    bottom_scale = 1;
    top_scale = 1 + 2 * tan(angle) * height / sqrt(length*length + width*width);
    
    scale([top_scale, top_scale, 1])
    translate([0, 0, height])
    mirror([0, 0, 1])
    linear_extrude(height=height, scale=bottom_scale/top_scale)
    phone_2d_shape(length, width, radius, smoothness);
}

// Module to create 2D iPhone shape
module phone_2d_shape(length, width, radius, smoothness) {
    hull() {
        for (x = [-1, 1], y = [-1, 1]) {
            translate([x * (length/2 - radius), y * (width/2 - radius)])
            superellipse(radius, radius, smoothness);
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
    charger_tray_height = cutout_height;
    
    // Main charger tray body
    translate([0, 0, -(chamfer_height + charger_tray_height/2)])
    cube([charger_tray_width, phone_width_with_clearance(), charger_tray_height], center=true);
    
    // Wedge
    translate([charger_tray_width/2, 0, -(chamfer_height + charger_tray_height)])
    rotate([90, 0, 0])
    wedge(wedge_length(), phone_width_with_clearance(), charger_tray_height);
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

// Calculate the wedge angle correctly
function wedge_angle() = atan2(cutout_height, wedge_length());

difference() {
    gridfinityInit(gridx, gridy, bin_height(), 0, sl=style_lip()) {
        cut_move(x=0, y=0, w=gridx, h=gridy) {
            allowance = 0.1;
            difference() {
                union() {
                    // Tapered iPhone shape (existing)
                    translate([0, 0, -chamfer_height])
                    cutout_chamfered_edge(phone_length_with_clearance(), 
                                        phone_width_with_clearance(), 
                                        chamfer_height + allowance, 
                                        phone_corner_radius_with_clearance(), 
                                        phone_corner_smoothness,
                                        chamfer_angle);
                    
                    // Non-tapered iPhone shape (existing)
                    translate([0, 0, -chamfer_height - cutout_height + allowance])
                    linear_extrude(height = cutout_height)
                    phone_2d_shape(phone_length_with_clearance(), 
                                    phone_width_with_clearance(), 
                                    phone_corner_radius_with_clearance(), 
                                    phone_corner_smoothness);
                }
                charger_tray();
            }   
        }
    }
    translate([
        0,
        0,
        bin_height()+4.75-chamfer_height-charger_cutout_depth_with_clearance()
    ])
    union() {
        // Circular cutout for charger
        // translate([0, 0, -charger_cutout_depth_with_clearance() - chamfer_height])
        cylinder(h = charger_cutout_depth_with_clearance() + 0.1, d = charger_cutout_diameter_with_clearance(), center = false);
        // Rectangular cutout for charging cable
        translate([
            0, 
            -cable_cutout_width/2, 
            cable_cutout_bottom_offset
        ])
        cube([cable_cutout_length + charger_cutout_diameter_with_clearance()/2, cable_cutout_width, cable_cutout_height], center=false);
        // Angled cutout extending to the edge of the tray
        translate([
            cable_cutout_length - 1 + charger_cutout_diameter_with_clearance()/2,
            -cable_cutout_width/2,
            cable_cutout_bottom_offset
        ])
        rotate([0, wedge_angle(), 0])
        cube([
            (gridx/2) * 42 - (charger_cutout_diameter_with_clearance()/2 + cable_cutout_length) + 5,
            cable_cutout_width,
            cable_cutout_height
        ]);
    }
}

gridfinityBase(gridx, gridy, l_grid, 0, 0, hole_options, only_corners=only_corners);