 include <flap_params.scad>;

module flap_frame_side() {
    // x=plate depth (into sim)
    // y=height
    // z=thickness
    difference() {
        cube([flap_body_d, bracket_y, flap_material_t]);
        // Bracket mounting holes
        let (hole_spacing = (bracket_y -2*bracket_wall_t)/(n_holes-1)) {
            for (i= [0:n_holes-1]) {
                translate([bracket_depth/2,hole_from_top + i*hole_spacing, -NOTHING]) cylinder(d=bracket_thru_hole_d, h=flap_material_t + 2*NOTHING);
            }
        }
        // // Standoff holes
        // translate([flap_body_d - flap_material_t/2, 32, -NOTHING]) cylinder(d=flap_side_hole_d, h=flap_material_t + 2*NOTHING);
    }
}

module flap_frame_side_servo() {
    translate([0,0,-flap_material_t]) difference() {
        flap_frame_side();
        translate([needle_from_front, needle_from_bottom - flap_bracket_y1, 0]) {
            rotate([0,0,180]) servo_cut(flap_material_t);
            // rotate([0,0,90]) servo_cut(flap_material_t);
        }
    }
}

module servo_cut(t=10) {
    translate([-servo_from_center_1, 0, -NOTHING]) union() {
        translate([0, -servo_from_center_2, 0]) cube([servo_w1, servo_w2, t+2*NOTHING]);
        translate([servo_w1, 0, 0]) servo_slot(t+2*NOTHING);
        rotate([0, 0, 180]) servo_slot(t + 2*NOTHING);
    }
}

module servo_slot(t=10) {
     union() {
        translate([-NOTHING, -servo_screw_slot_w2/2, 0]) cube([servo_screw_slot_w1 + NOTHING, servo_screw_slot_w2, t]);
        translate([servo_screw_slot_w1, 0, 0]) cylinder(d=servo_screw_slot_w2, h= t);
    }
}

module flap_frame_side_pot() {
    difference() {
        flap_frame_side();
        translate([lever_from_front, lever_from_bottom - flap_bracket_y1, -NOTHING]) {
            cylinder(d=flap_pot_hole_d, h=flap_material_t+2*NOTHING);
            // Locating holes for potentiometer tab, every 90 degrees
            for (i = [0:3]) {
                rotate([0,0,90*i]) translate([flap_pot_tab_r_from_center, 0, 0]) cylinder(d=flap_pot_tab_w, h=flap_material_t + 2*NOTHING);
            }
        }
    }
}

module frame_bracket() {
    let (tab_width=8, notch_depth=6, bracket_h=20, plate_outer_gap=flap_body_w - flap_bracket_x1 - flap_bracket_x2)
    translate([-tab_width, -notch_depth, 0]) difference() {
        cube([plate_outer_gap + 2*tab_width, bracket_h, flap_material_t]);
        translate([tab_width, -NOTHING, -NOTHING]) cube([flap_material_t, notch_depth+NOTHING, flap_material_t+2*NOTHING]);
        translate([tab_width + plate_outer_gap - flap_material_t, -NOTHING, -NOTHING]) cube([flap_material_t, notch_depth+NOTHING, flap_material_t+2*NOTHING]);
        translate([plate_outer_gap/2 + tab_width, bracket_h - (bracket_h - notch_depth)/2 , -NOTHING]) cylinder(d=3, h=flap_material_t+2*NOTHING);    }
}

// OUTPUTS

// LASER
// projection() flap_frame_side_servo();
projection() flap_frame_side_pot();

// STL
// flap_frame_side_servo();
// flap_frame_side_pot();

