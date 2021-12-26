
include <flap_params.scad>;
use <flap_lever.scad>;
use <flap_plate.scad>;


NOTHING = 0.01;

flap_positions = [
    [0, 0],
    [12.8, 0],
    [21.2, 2.8],
    [29.95, 4.9],
];

module flap_assembly() {
    flap_position = flap_positions[$t*len(flap_positions)];
    // color("white") translate([-frame_cut_w/2,0,0]) cube([frame_cut_w, frame_cut_d, frame_cut_h]);
    translate([-flap_body_w/2,0,0]) union() {
        translate([lever_from_left, lever_from_front, lever_from_bottom]) rotate([-90, 0, -90]) flap_lever(flap_position[0], flap_position[1]);
        translate([0,0,0]) rotate([90,0,0]) flap_plate();
        translate([needle_from_left,needle_from_front, needle_from_bottom]) rotate([-90,0,-90]) needle(0);
        rotate([90, 0, 0]) flap_body(10);
    }
}

module project_frame(solid_color=false) {
    if (solid_color) {
        color("white");
    }
    translate([-proj_view_neg_x, 0, 0]) union() {
        difference() {
            union() {
                // "FLOOR"
                color(color_frame) translate([0, proj_facade_d + proj_frame_d, 0]) cube([proj_view_w, proj_view_d, (proj_h_from_desk-proj_h_from_floor)]);

                // "FRAME"
                color(color_frame) translate([0, proj_facade_d, -proj_facade_h + proj_h_from_desk]) cube([proj_view_w, proj_frame_d, proj_view_h]);

                // "FACADE"
                color(color_facade) translate([0, 0, -proj_facade_h + proj_h_from_desk]) cube([proj_view_w, proj_facade_d, proj_facade_h]);
            }
            translate([proj_view_neg_x-frame_cut_w/2 -NOTHING, -NOTHING, flap_offset_from_desk + (flap_body_h-frame_cut_h)/2-NOTHING]) cube([frame_cut_w + 2*NOTHING, frame_cut_h+2*NOTHING, frame_cut_d+ 2*NOTHING]);
        }
        // DESK
        color(color_desk) translate([0, proj_facade_d + proj_frame_d + proj_desk_gap_d, -proj_desk_h]) cube([proj_view_w, proj_view_d, proj_desk_h]);
    }
}

project_frame();
translate([0, 0, flap_offset_from_desk]) flap_assembly();