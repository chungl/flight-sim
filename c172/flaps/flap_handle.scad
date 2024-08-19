include <flap_params.scad>;
include <flap_lever_params.scad>;
use <flap_lever.scad>;

handle_edge_r=0.5;
handle_w=25;
handle_h1=32;
handle_h2=34;
handle_base_t2=11;
handle_base_t1=9;
handle_end_t1=3;
handle_end_t2=5;

lever_slot_w=handleSlotW+0.1;
lever_slot_h=handleSlotH+0.1;
lever_slot_d=handleSlotD;

$fn=180;
NOTHING=0.01;

module ball() {
    sphere(r=handle_edge_r);
}

module _half() {
    hull() {
        // BASE
        // Upper right
        translate([handle_w/2-handle_edge_r, handle_base_t1/2-handle_edge_r, 0]) ball();
        // Lower right
        translate([handle_w/2-handle_edge_r, -(handle_base_t1/2-handle_edge_r), 0]) ball();
        // Upper center
        translate([0,handle_base_t2/2 - handle_edge_r,0]) ball();
        // Lower center
        translate([0,-(handle_base_t2/2 - handle_edge_r),0]) ball();
        // TOP
        // Upper right
        translate([handle_w/2-handle_edge_r, handle_end_t1/2-handle_edge_r, handle_h1-handle_edge_r]) ball();
        // Lower right
        translate([handle_w/2-handle_edge_r, -(handle_end_t1/2-handle_edge_r), handle_h1-handle_edge_r]) ball();
        // Upper center
        translate([0, handle_end_t2/2-handle_edge_r, handle_h2-handle_edge_r]) ball();
        // Lower center
        translate([0, -(handle_end_t2/2-handle_edge_r), handle_h2-handle_edge_r]) ball();
    }
}

module flap_lever_handle() {
    difference() {
        union() {
            _half();
            rotate([0,0,180]) _half();
        }
        // Flatten bottom
        translate([-handle_w/2-NOTHING, -handle_base_t2/2-NOTHING, -handle_edge_r-NOTHING]) cube([handle_w+2*NOTHING, handle_base_t2+2*NOTHING, handle_edge_r+NOTHING]);
        rotate([0,-90,0]) lever_bore();
    }
}

module lever_bore() {
    color("orange") hull() {
        cylinder(d=lever_slot_h, h=lever_slot_w, center=true);
        translate([lever_slot_d-lever_slot_h, 0, 0]) cylinder(d=lever_slot_h, h=lever_slot_w, center=true);
    }
}

module _lever_assembly_preview() {
    color("lightgray") 
    translate([-handleVisibleOffset, 0, -armBaseT/2]) rotate([0,0,handleA]) translate([-armL,0,0]) rotate([0,0,180]) mirror_lever();
    rotate([90,90,90]) 
    difference() {
        flap_lever_handle();
        translate([-(handle_w/2+NOTHING),-(handle_base_t2/2+NOTHING),-NOTHING]) cube([handle_w/2+NOTHING, handle_base_t2+2*NOTHING, handle_h2+2*NOTHING]);
    }
}

// _lever_assembly_preview();

// OUTPUTS

flap_lever_handle();
