include <gridfinity-rebuilt-openscad/gridfinity-rebuilt-utility.scad>

include <components/charger-cutout.scad>
include <components/charger-tray.scad>
include <components/phone.scad>

// ===== PHONE PARAMETERS ===== //

/* [Phone Size] */
// Just the phone cutout so the dimensions can be tested
test_phone_cutout = false;

// Known phone dimensions. It is recommended to do a test print first if using untested or custom phone dimensions
phone_preset = 1; // [0: Custom, 1: iPhone 16 Pro Max, 2: iPhone 16 Pro !UNTESTED!, 3:iPhone 16 Plus !UNTESTED!, 4:iPhone 16 !UNTESTED!]

function phone_presets() = 
    // Length, Width, Corner Curve, Corner Smoothness
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
// Clearance around Phone (per side) - can be used to accomdate a phone case
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
charger_preset = 1; // [0: Custom, 1: Apple MagSafe Charger !UNTESTED!, 2: Belkin MagSafe Wireless Charger Pad !UNTESTED!, 3: Mous Mage MagSafe Charger]

function charger_presets() = 
    // Diameter, Depth, Cable Width, Plug Width, Cable Relief Diameter, Cable Relief Length
    charger_preset == 1 ? [55.5, 4.37, 2.85, 10.15, 2.85, 5] : // Apple MagSafe Charger
    charger_preset == 2 ? [58.5, 11.7, 4.4, 12, 7, 20] : // Belkin MagSafe Wireless Charger Pad
    charger_preset == 3 ? [56.8, 7.5, 2.75, 11.5, 3.8, 10] : // Mous MagSafe Charger
    [0, 0, 0, 0, 0]; // Custom

// Diameter of the circular cutout in the charger tray
custom_charger_diameter = 55.5;
// Depth of the circular cutout in the charger tray
custom_charger_cutout_depth = 4.37;
// Cable Diameter
custom_cable_diameter = 3;
// Cable Plug Width
custom_cable_plug_width = 5;
// Width of the cable cutout
custom_cable_relief_diameter = 5; //.1
// Height of the cable cutout
custom_cable_relief_length = 11; //.1

function charger_diameter() = (charger_preset == 0 ? custom_charger_diameter : charger_presets()[0])  + 2*charger_cutout_clearance;
function charger_height() = charger_preset == 0 ? custom_charger_cutout_depth : charger_presets()[1];

function cable_diameter() = (charger_preset == 0 ? custom_cable_diameter : charger_presets()[2]);
function cable_plug_width() = (charger_preset == 0 ? custom_cable_plug_width : charger_presets()[3]) + cable_plug_clearance;
function cable_relief_diameter() = (charger_preset == 0 ? custom_cable_relief_diameter : charger_presets()[4]);
function cable_relief_length() = (charger_preset == 0 ? custom_cable_relief_length : charger_presets()[5]);
function cable_cutout_height() = bin_height()+4.75-phone_chamfer_height+0.02-charger_height();

function wedge_length() = (phone_length() - charger_tray_size)/2;

/* [Charger Tray] */
// Size of the charger tray extrusion
charger_tray_size = 70.0;
// Clearance around the charger cutout
charger_cutout_clearance = 0.8;
// Cable cutout clearance
cable_cutout_clearance = 1;
// Cable management clearance
cable_management_clearance = 0.3;
// Cable plug clearance
cable_plug_clearance = 0.5;

// ===== GRIDFINITY PARAMETERS ===== //

/* [Gridfinity Grid] */
// number of bases along x-axis
gridx = 4; //.5
// number of bases along y-axis
gridy = 2; //.5
// bin height (leave as 0 to auto calculate based on charger size) - see bin height information and "gridz_define" below
gridz = 0; //.1

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
function auto_gridz() = ceil((charger_height()+phone_chamfer_height+2)/7);
function bin_height() = gridz > 0 ? height(gridz, gridz_define, style_lip(), enable_zsnap) : height(auto_gridz(), 0, style_lip(), false);
function base_height() = 4.75;
function tray_length() = gridx * 42;

// echo(bin_height());

// ===== MODULES ===== //

// Module to create tapered iPhone shape
module cutout_chamfered_edge(length, width, height, curve, smoothness, angle) {
    bottom_scale = 1;
    top_scale = 1 + 2 * tan(angle) * height / 100;

    echo(sqrt(length*length + width*width))
    
    scale([top_scale, top_scale, 1])
    translate([0, 0, height])
    mirror([0, 0, 1])
    linear_extrude(height=height, scale=bottom_scale/top_scale)
    phone_2d_shape(length, width, curve, smoothness);
}

color("#FFFFFF")
if (test_phone_cutout) {
    difference() {
        translate([0, 0, phone_chamfer_height/2])
        cube([phone_length()+5, phone_width()+5, phone_chamfer_height-0.01], center=true);
        linear_extrude(height = phone_chamfer_height, scale = 1 + 2 * tan(phone_chamfer_angle) * (phone_chamfer_height / 100)) 
        phone_2d_shape(phone_length(), 
                            phone_width(), 
                            phone_corner_curve(), 
                            phone_corner_smoothness());
                            translate([0, 0, -phone_cutout_height]);
    }
} else if (test_charger_cutout) {
    fake_bin_height = charger_height();
    fake_base_height = 1;
    difference() {
        translate([0, 0, (fake_bin_height + fake_base_height)/2])
        union() {
            cylinder(h = fake_bin_height + fake_base_height, d = charger_diameter() + 3, center = true, $fn=50);
            translate([(charger_diameter() + 2)/2, 0, 0])
            cube([cable_relief_length()+5, cable_relief_diameter()+3, fake_bin_height + fake_base_height], center = true);
        }
        translate([0,0,0.01])
        charger_cutout(
            bin_height = fake_bin_height,
            base_height = fake_base_height,
            tray_length = tray_length(),
            charger_height = charger_height(), 
            charger_diameter = charger_diameter(), 
            plug_width = cable_plug_width(), 
            cable_diameter = cable_diameter(), 
            cable_cutout_clearance = cable_cutout_clearance,
            cable_management_clearance = cable_management_clearance,
            cable_relief_length = cable_relief_length(), 
            cable_relief_diameter = cable_relief_diameter()
        );
    }
} else {
    difference() {
        union() {
            gridfinityInit(gridx, gridy, bin_height(), 0, sl=style_lip()) {
                cut_move(x=0, y=0, w=gridx, h=gridy) {
                    translate([0, 0, -phone_chamfer_height + 0.01])
                    union() {
                        // Top Chamfer
                        linear_extrude(height = phone_chamfer_height, scale = 1 + 2 * tan(phone_chamfer_angle) * (phone_chamfer_height / 100)) 
                        phone_2d_shape(phone_length(), 
                                            phone_width(), 
                                            phone_corner_curve(), 
                                            phone_corner_smoothness());
                                            translate([0, 0, -phone_cutout_height]);
                        // Phone cutout with charger tray
                        translate([0, 0, -phone_cutout_height + 0.01])
                        difference() {
                            // Cutout
                            linear_extrude(height = phone_cutout_height)
                            phone_2d_shape(phone_length(), 
                                            phone_width(), 
                                            phone_corner_curve(), 
                                            phone_corner_smoothness());
                                            translate([0, 0, -phone_cutout_height]);
                            // Charger tray
                            translate([0, 0, phone_cutout_height/2])
                            charger_tray(phone_cutout_height, phone_width(), charger_tray_size, wedge_length(), 1);
                        }
                    }
                }
            }
            if (base_plate_enabled) {
                gridfinityBase(gridx, gridy, l_grid, 0, 0, hole_options, only_corners=only_corners);
            }
        }
        
        translate([0, 0, 0.1])
        charger_cutout(
            bin_height = bin_height() - phone_chamfer_height,
            base_height = base_height(),
            tray_length = tray_length(),
            charger_height = charger_height(), 
            charger_diameter = charger_diameter(), 
            plug_width = cable_plug_width(), 
            cable_diameter = cable_diameter(), 
            cable_cutout_clearance = cable_cutout_clearance,
            cable_management_clearance = cable_management_clearance,
            cable_relief_length = cable_relief_length(), 
            cable_relief_diameter = cable_relief_diameter()
        );
    }
}