include <flap_params.scad>;
include <../elec_panel/switch_plate.scad>;

_plate_hole_overlap=1;
plate_w=frame_cut_w+_plate_hole_overlap*2;
plate_h=frame_cut_h+_plate_hole_overlap*2;

plate_t=flap_plate_t;
plate_r=flap_plate_r;

mounting_hole_d=2;
mounting_hole_inset_from_frame=flap_bracket_y1/2;

// 0-10 degrees
lever_slot_w1=7.85;
lever_slot_h1=22.4;
// 10-20 degrees
lever_slot_w2=5.0;
lever_slot_h2=8.9;
// 20 degrees - full
lever_slot_w3=2.75;
lever_slot_h3=10.1;
lever_slot_h = lever_slot_h1+lever_slot_h2+lever_slot_h3;

lever_slot_top_from_axis=34;

// match flap_lever.scad
_needle_w=2.8;

needle_slot_clearance=0.4;
needle_slot_h=35.2;

needle_slot_w=_needle_w+2*needle_slot_clearance;
needle_slot_from_left = needle_from_left + (needle_slot_w/2 -needle_slot_clearance);

// Detent labels
// Detent label region spands from the right of the needle slot to the left edge of the lever detent region.
detent_label_from_left = needle_slot_from_left + needle_slot_w;
detent_label_w = lever_from_left - detent_label_from_left + (lever_slot_w1 - lever_slot_w3);

NOTHING=.1;

module mounting_holes(d, h, NOTHING=NOTHING) {
    translate([mounting_hole_inset_from_frame,mounting_hole_inset_from_frame,-NOTHING]) cylinder(d=d, h=h+2*NOTHING);
    translate([flap_body_w - mounting_hole_inset_from_frame,mounting_hole_inset_from_frame,-NOTHING]) cylinder(d=d, h=h+2*NOTHING);
    translate([flap_body_w - mounting_hole_inset_from_frame,flap_body_h - mounting_hole_inset_from_frame,-NOTHING]) cylinder(d=d, h=h+2*NOTHING);
    translate([mounting_hole_inset_from_frame,flap_body_h - mounting_hole_inset_from_frame,-NOTHING]) cylinder(d=d, h=h+2*NOTHING);
}

module position_detents() {
    translate([lever_from_left, lever_from_bottom + lever_slot_top_from_axis, -NOTHING]) children();
}

// Shape of detent slot for flap lever
// Relative to upper left corner (index position for flaps@0);
module detents() {
    translate([lever_slot_w1, -lever_slot_h, 0]) union() {
        translate([-lever_slot_w1,lever_slot_h2+lever_slot_h3-NOTHING,0]) cube([lever_slot_w1,lever_slot_h1+NOTHING,plate_t+2*NOTHING]);
        translate([-lever_slot_w2,lever_slot_h3-NOTHING,0]) cube([lever_slot_w2,lever_slot_h2+NOTHING,plate_t+2*NOTHING]);
        translate([-lever_slot_w3,0,0]) cube([lever_slot_w3,lever_slot_h3,plate_t+2*NOTHING]);
    }
}

$fn=100;
module flap_plate() {
    difference() {
        // Plate w/ overlap
        translate([plate_r-(plate_w - flap_body_w)/2, plate_r-(plate_h-flap_body_h)/2, 0])  minkowski() {
            cube([plate_w-2*plate_r, plate_h-2*plate_r, plate_t/2]);
            cylinder(r=plate_r, h=plate_t/2);
        }
        // Lever detents
        position_detents() detents();
        // Needle slot
        translate([needle_slot_from_left,needle_from_bottom-(needle_slot_h-needle_slot_w)/2,-NOTHING]) hull() {
            cylinder(d=needle_slot_w, h=plate_t+2*NOTHING);
            translate([0,needle_slot_h-needle_slot_w, -NOTHING]) cylinder(d=needle_slot_w, h=plate_t+2*NOTHING);
        }
        // Plate mounting holes
        translate([0,0,]) mounting_holes(d=mounting_hole_d, h=flap_plate_t+2*NOTHING);
        

    }
}



// 0 - 10 degrees
detent_region_blue_h = lever_slot_h1;
// 10 degrees to full
detent_region_white_h = lever_slot_h - detent_region_blue_h;

// Positioned relative to upper left corner of detents
module detent_labels() {
    translate([-detent_label_w + (lever_slot_w1-lever_slot_w3), -lever_slot_h, 0]) {
        // Relative to lower left corner of labels
        // white region
        color("white") square([detent_label_w, detent_region_white_h]);
        color("deepskyblue") translate([0, detent_region_white_h]) {
            square([detent_label_w, detent_region_blue_h]);
            translate([(lever_slot_from_left - detent_label_from_left)/2, detent_region_blue_h/2]) vertical_text_array(["1", "1", "0"], valign="center", halign="center");
        }
    }

}
module flap_plate_label() {
    difference() {
        position_detents() detent_labels();
        projection() flap_plate();
    }
}

module flap_body(d=flap_body_d) {
    translate([0,0,-d]) difference() {
        cube([flap_body_w, flap_body_h, d]);
        translate([flap_bracket_x1, flap_bracket_y1, -NOTHING]) cube([flap_body_w-flap_bracket_x1-flap_bracket_x2, flap_body_h-flap_bracket_y1-flap_bracket_y2, d+2*NOTHING]);
        mounting_holes(d=mounting_hole_d, h=d);
    }
}

flap_plate();
// flap_plate_label();
// detents();
// flap_body(d=10);