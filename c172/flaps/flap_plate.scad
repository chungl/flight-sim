include <flap_params.scad>;

_plate_hole_overlap=1;
plate_w=frame_cut_w+_plate_hole_overlap*2;
plate_h=frame_cut_h+_plate_hole_overlap*2;
plate_r=3.4;
plate_t=2.1;

lever_slot_w1=7.85;
lever_slot_h1=22.4;
lever_slot_w2=5.0;
lever_slot_h2=8.9;
lever_slot_w3=2.75;
lever_slot_h3=10.1;

lever_slot_top_from_axis=34;

// match flap_lever.scad
_needle_w=2.8;

needle_slot_clearance=0.4;
needle_slot_h=35.2;

needle_slot_w=_needle_w+2*needle_slot_clearance;

NOTHING=1;


$fn=100;
module flap_plate() {
    difference() {
        translate([plate_r-(plate_w - flap_body_w)/2, plate_r-(plate_h-flap_body_h)/2, 0])  minkowski() {
            cube([plate_w-2*plate_r, plate_h-2*plate_r, plate_t/2]);
            cylinder(r=plate_r, h=plate_t/2);
        }
        translate([lever_slot_w1 + lever_from_left,-(lever_slot_h1+lever_slot_h2+lever_slot_h3) + lever_from_bottom + lever_slot_top_from_axis, -NOTHING]) union() {
            translate([-lever_slot_w1,lever_slot_h2+lever_slot_h3-NOTHING,0]) cube([lever_slot_w1,lever_slot_h1+NOTHING,plate_t+2*NOTHING]);
            translate([-lever_slot_w2,lever_slot_h3-NOTHING,0]) cube([lever_slot_w2,lever_slot_h2+NOTHING,plate_t+2*NOTHING]);
            translate([-lever_slot_w3,0,0]) cube([lever_slot_w3,lever_slot_h3,plate_t+2*NOTHING]);
        }
        translate([needle_from_left + (needle_slot_w/2 -needle_slot_clearance),needle_from_bottom-(needle_slot_h-needle_slot_w)/2,-NOTHING]) hull() {
            cylinder(d=needle_slot_w, h=plate_t+2*NOTHING);
            translate([0,needle_slot_h-needle_slot_w, -NOTHING]) cylinder(d=needle_slot_w, h=plate_t+2*NOTHING);
        }
    }
}

module flap_body(d=flap_body_d) {
    translate([0,0,-d]) difference() {
        cube([flap_body_w, flap_body_h, d]);
        translate([flap_bracket_x1, flap_bracket_y1, -NOTHING]) cube([flap_body_w-flap_bracket_x1-flap_bracket_x2, flap_body_h-flap_bracket_y1-flap_bracket_y2, d+2*NOTHING]);
    }
}