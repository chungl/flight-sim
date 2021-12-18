
include <flap_params.scad>;
use <flap_lever.scad>;

NOTHING = 0.01;

module flap_assembly() {
    // color("white") translate([-frame_cut_w/2,0,0]) cube([frame_cut_w, frame_cut_d, frame_cut_h]);
    translate([10, 40, 40]) rotate([-90, 0, -90]) flap_lever();
}

module project_frame(solid_color=false) {
    if (solid_color) {
        color("white");
    }
    translate([-proj_view_neg_x, 0, 0]) union() {
        difference() {
            union() {
                // "FLOOR"
                color("wheat") translate([0, proj_facade_d + proj_frame_d, 0]) cube([proj_view_w, proj_view_d, (proj_h_from_desk-proj_h_from_floor)]);

                // "FRAME"
                color("wheat") translate([0, proj_facade_d, -proj_facade_h + proj_h_from_desk]) cube([proj_view_w, proj_frame_d, proj_view_h]);

                // "FACADE"
                color("burlywood") translate([0, 0, -proj_facade_h + proj_h_from_desk]) cube([proj_view_w, proj_facade_d, proj_facade_h]);
            }
            translate([proj_view_neg_x-frame_cut_w/2 -NOTHING, -NOTHING, -NOTHING]) cube([frame_cut_w + 2*NOTHING, frame_cut_h+2*NOTHING, frame_cut_d+ 2*NOTHING]);
        }
        // DESK
        color("darkgray") translate([0, proj_facade_d + proj_frame_d + proj_desk_gap_d, -proj_desk_h]) cube([proj_view_w, proj_view_d, proj_desk_h]);
    }
}

project_frame();
flap_assembly();