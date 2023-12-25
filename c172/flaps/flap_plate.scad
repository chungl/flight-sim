include <flap_params.scad>;
include <../text_utils.scad>;

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

needle_slot_w=_needle_w+2*needle_slot_clearance;
needle_slot_from_left = needle_from_left + (needle_slot_w/2 -needle_slot_clearance);
needle_slot_h=lever_slot_h+needle_slot_w;

// Detent labels
// Detent label region spands from the right of the needle slot to the left edge of the lever detent region.
detent_label_from_left = needle_slot_from_left + needle_slot_w/2;
detent_label_w_primary = lever_from_left - detent_label_from_left;
detent_label_w_full = detent_label_w_primary + (lever_slot_w1 - lever_slot_w3);

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

module flap_plate_blank() {
    translate([plate_r-(plate_w - flap_body_w)/2, plate_r-(plate_h-flap_body_h)/2, 0])  minkowski() {
            cube([plate_w-2*plate_r, plate_h-2*plate_r, plate_t/2]);
            cylinder(r=plate_r, h=plate_t/2);
        }
}
$fn=100;
module flap_plate() {
    difference() {
        // Plate w/ overlap
        flap_plate_blank();
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
detent_text_from_left = needle_slot_from_left-needle_slot_w/2-1;

module detent_labels() {
    // Positioned relative to upper right corner of flaps@0 label
    translate([0,-lever_slot_h]) {
        translate([0,lever_slot_h]) text("UP", font=font, size=text_size, valign="top", halign="right");
        translate([0,lever_slot_h-lever_slot_h1]) text("10°", font=font, size=text_size, valign="center", halign="right");
        translate([0,lever_slot_h3]) text("20°", font=font, size=text_size, valign="center", halign="right");
        text("FULL", font=font, size=text_size, valign="bottom", halign="right");


    }
}

// Positioned relative to upper left corner of detents
module detent_speed_regions() {
    translate([-detent_label_w_primary, -lever_slot_h, 0]) {
        // Relative to lower left corner of labels
        // white region
        color("white") difference() {
            square([detent_label_w_full, detent_region_white_h]);
            translate([detent_label_w_primary/2, detent_region_white_h/2]) vertical_text_array(["8","5"], char_align_index=0.5, halign="center");
        }
        color("deepskyblue") translate([0, detent_region_white_h]) difference() {
            // square([detent_label_w_primary, detent_region_blue_h]);
            translate([detent_label_w_primary/2, detent_region_blue_h/2]) vertical_text_array(["1", "1", "0"], char_align_index=1, halign="center");
        }
    }
}

module flap_plate_label() {
        translate([lever_from_left, lever_from_bottom + lever_slot_top_from_axis]) detent_speed_regions();
        translate([lever_from_left, lever_from_bottom + lever_slot_top_from_axis]) color("white") translate([-detent_label_w_primary-needle_slot_w-1,-0]) 
            detent_labels();
        color("white") translate([1.5,flap_body_h/2]) vertical_text_array(["W","I","N","G"," ","F","L","A","P","S"],char_align_index=4.5,halign="center");
}

module flap_body(d=flap_body_d) {
    translate([0,0,-d]) difference() {
        cube([flap_body_w, flap_body_h, d]);
        translate([flap_bracket_x1, flap_bracket_y1, -NOTHING]) cube([flap_body_w-flap_bracket_x1-flap_bracket_x2, flap_body_h-flap_bracket_y1-flap_bracket_y2, d+2*NOTHING]);
        mounting_holes(d=mounting_hole_d, h=d);
    }
}

// color("black") translate([0,0,-plate_t]) flap_plate();
// flap_plate();
// flap_plate_label();
// detents();
// flap_body(d=10);
difference() {
    projection() flap_plate_blank();
    flap_plate_label();
//    translate([lever_from_left, lever_from_bottom + lever_slot_top_from_axis]) detent_speed_regions();
    
//     translate([lever_from_left, lever_from_bottom + lever_slot_top_from_axis]) color("white") translate([-detent_label_w_primary-needle_slot_w-1,-0]) 
//             detent_labels();
//     color("white") translate([1.5,flap_body_h/2]) vertical_text_array(["W","I","N","G"," ","F","L","A","P","S"],char_align_index=4.5,halign="center");

}