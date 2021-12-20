// Current implementation only supports 90 - 180 degrees. Update "Arc Between" section for different range.
total_angle=120;
start_key_angle_from_center=-total_angle/2;
lock_flat_angle_from_key=0;

lock_body_diameter=19;
lock_body_flat_diameter=16.5;
wafer_slot_diameter=15.0;
wafer_slot_width=5.5;
tumbler_diameter=13;
wafer_slot_depth=26.4-3.6;

tumbler_square_width=8.6;
tumbler_square_offset_from_key=0;
square_depth=2.2;
lock_screw_depth=2.2;
lock_nut_relief_d=27;
lock_nut_relief_w=7;
lock_body_clamp_hole_d=0;
lock_body_clamp_hole_h=7.5;
lock_body_clamp_hole_from_center=12;
access_hole_d=0;

pin_angle_from_start=0;
pin_r_from_center=(lock_body_diameter+tumbler_diameter)/4;
lock_pin_slot_t=2;
lock_pin_w=2.9;
_lock_pin_half_angle=atan(lock_pin_slot_t/(2*pin_r_from_center));

coupler_length=20.8+square_depth;
coupler_d=20;
coupler_chamfer_d=14;
coupler_chamfer_h=3;

screw_head_diameter=12;
screw_d=6.8;
screw_head_t=4;
coupler_screw_access_depth=9;

coupler_switch_shaft_d=5.85;
coupler_set_screw_d=2.4;
coupler_set_screw_from_top=4;

frame_t=4.75;
frame_base_t=4;
center_from_floor=16.5;
frame_d=33;
frame_length=45.7;

switch_d=9.5;
switch_d2=12;
switch_d2_t=0.75;
switch_locator_d=3.8;
switch_locator_from_center=11.7;

spring_hole_diam=3.0;
spring_hole_depth=(frame_d-lock_body_diameter)/2-0.75;
num_spring_holes=6;
spring_hole_angle_between=90/(num_spring_holes-1);
spring_hole_first_angle=0;

lock_spacer_t=12.2;

support_layer_height=0.0;

NOTHING=0.1;
$fn=100;

function polar_y_to_cartesian(a, r) = [r*sin(a), r*cos(a)];

module frame(spacer=false) {

    difference() {
        union() {
            translate([0,0,center_from_floor]) rotate([0,90,0]) cylinder(d=frame_d, h=frame_length);
            translate([0,-frame_d/2, 0]) cube([frame_length, frame_d, center_from_floor]);
            if (spacer) {
                translate([-lock_spacer_t, 0, center_from_floor]) rotate([0,90,0]) rotate([0,0,-90 + start_key_angle_from_center]) lock_spacer();
            }
        }
        // CUT OFF ANY EXTRA CYLINDER
        translate([-NOTHING,-frame_d/2-NOTHING,-frame_d-NOTHING]) cube([frame_length+2*NOTHING, frame_d+2*NOTHING, frame_d+NOTHING]);
        // MAIN BODY CUT
        translate([frame_t, -frame_d/2-NOTHING, frame_base_t]) cube([frame_length - 2*frame_t, frame_d + 2*NOTHING, frame_d/2 + center_from_floor+NOTHING]);
        // HOLE FOR LOCK BODY
        translate([-NOTHING, 0, center_from_floor]) rotate([0,90,0]) cylinder(d=lock_body_diameter, h=frame_t+2*NOTHING);
        // RELIEF TO ALLOW LOCK'S NUT TO ROTATE
        translate([frame_t, 0, center_from_floor]) rotate([0,90,0]) cylinder(d=lock_nut_relief_d, h=lock_nut_relief_w);
        // HOLES TO ATTACH THE LOCK CLAMP/SPACER
        translate([-NOTHING, lock_body_clamp_hole_from_center, lock_body_clamp_hole_h]) rotate([0,90,0]) cylinder(d=lock_body_clamp_hole_d, h=frame_t+2*NOTHING);
        translate([-NOTHING, -lock_body_clamp_hole_from_center, lock_body_clamp_hole_h]) rotate([0,90,0]) cylinder(d=lock_body_clamp_hole_d, h=frame_t+2*NOTHING);
        // HOLES FOR TOOL ACCESS TO THE ABOVE LOCK CLAMP SCREWS
        translate([frame_length-frame_t-NOTHING, lock_body_clamp_hole_from_center, lock_body_clamp_hole_h]) rotate([0,90,0]) cylinder(d=access_hole_d, h=frame_t+2*NOTHING);
        translate([frame_length-frame_t-NOTHING, -lock_body_clamp_hole_from_center, lock_body_clamp_hole_h]) rotate([0,90,0]) cylinder(d=access_hole_d, h=frame_t+2*NOTHING);
        // HOLE TO MOUNT THE SWITCH
        translate([frame_length-frame_t-NOTHING, 0, center_from_floor]) rotate([0,90,0]) cylinder(d=switch_d, h=frame_t+2*NOTHING);
        translate([frame_length-switch_d2_t, 0, center_from_floor]) rotate([0,90,0]) cylinder(d=switch_d2, h=switch_d2_t+NOTHING);
        // SWITCH LOCATOR PIN HOLE
        translate([frame_length-frame_t-NOTHING, 0, center_from_floor - switch_locator_from_center]) rotate([0,90,0]) cylinder(d=switch_locator_d, h=frame_t+2*NOTHING);

        // SPRING HOLES;
        translate([0,0,center_from_floor]) for ( i = [0 : num_spring_holes - 1]) {
            rotate([i*spring_hole_angle_between + spring_hole_first_angle, 0, 0]) translate([frame_t/2, 0, frame_d/2 - spring_hole_depth]) cylinder(d=spring_hole_diam, h=2*spring_hole_depth);
            rotate([i*spring_hole_angle_between + spring_hole_first_angle, 0, 0]) translate([frame_length - frame_t/2, 0, frame_d/2 - spring_hole_depth]) cylinder(d=spring_hole_diam, h=2*spring_hole_depth);
        }
    }
}

module coupler() {
    /*
    ORIENTATION NOTES:
    Print: as designed.
    Assembly: 
        * XY plane @ z=0 is the face that will mate to the lock cylinder.
        * The opposite face will mate to the rotary switch.
        * The side of the cylinder on the negative Y axis (as modeled) will be at the top when the switch is in the "off" position.
        * The operation `translate([90, 0, 90])` 

    */
    difference() {
        // COUPLER BODY
        union() {
            cylinder(d=coupler_d, h=coupler_length - coupler_chamfer_h);
            translate([0,0,coupler_length - coupler_chamfer_h]) cylinder(d1=coupler_d, d2=coupler_chamfer_d, h=coupler_chamfer_h);
        }
        // SQUARE RECESS FOR LOCK TUMBLER
        translate([-tumbler_square_width/2, -tumbler_square_width/2, -NOTHING]) cube([tumbler_square_width, tumbler_square_width, square_depth+NOTHING]);
        // LOCK SCREW HOLE
        translate([0,0, square_depth + support_layer_height]) cylinder(d=screw_d, h=lock_screw_depth -support_layer_height + NOTHING);
        // LOCK SCREW HEAD CHAMBER
        translate([0,0, square_depth + lock_screw_depth]) cylinder(d=screw_head_diameter, h=coupler_screw_access_depth);
        // LOCK SCREW ACCESS SLOT (HEAD)
        translate([0,0, square_depth + lock_screw_depth + coupler_screw_access_depth - screw_head_t]) hull() {
            cylinder(d=screw_head_diameter, h=screw_head_t);
            rotate([0,0, -start_key_angle_from_center]) translate([0, -coupler_d/2, 0]) cylinder(d=screw_head_diameter, h=screw_head_t);
        }
        // LOCK SCREW ACCESS SLOT (SHAFT)
        translate([0,0, square_depth + support_layer_height]) hull() {
            cylinder(d=screw_d, h=lock_screw_depth + coupler_screw_access_depth - support_layer_height);
            rotate([0,0, -start_key_angle_from_center]) translate([0, -coupler_d/2, 0]) cylinder(d=screw_d+2, h=lock_screw_depth + coupler_screw_access_depth - support_layer_height);
        }
        // SWITCH SHAFT HOLE
        translate([0,0, square_depth + lock_screw_depth + coupler_screw_access_depth + support_layer_height -NOTHING]) cylinder(d=coupler_switch_shaft_d, h=coupler_length-square_depth-lock_screw_depth-coupler_screw_access_depth + 2*NOTHING - support_layer_height);
        // SWITCH SET SCREW HOLES
        rotate([0,0,-start_key_angle_from_center]) translate([0,0,coupler_length-coupler_set_screw_from_top]) rotate([90, 0, 0]) cylinder(d=coupler_set_screw_d, h=coupler_d);
        rotate([0,0,-start_key_angle_from_center - 90]) translate([0,0,coupler_length-coupler_set_screw_from_top]) rotate([90, 0, 0]) cylinder(d=coupler_set_screw_d, h=coupler_d);

        // LOCK ROTATION RESTRICTION SLOT
        rotate([0,0,pin_angle_from_start]) union() {
            // Start: 
            translate([0,-pin_r_from_center, -NOTHING]) cylinder(d=lock_pin_slot_t, h=square_depth+NOTHING);
            // End
            rotate([0,0, -total_angle]) translate([0,-pin_r_from_center, -NOTHING]) cylinder(d=lock_pin_slot_t, h=square_depth+NOTHING);
            // Arc Between
            translate([0,0,-NOTHING]) difference() {
                // Outer edge of arc
                cylinder(r=pin_r_from_center + lock_pin_slot_t/2, h= square_depth + NOTHING);
                // Inner edge of arc
                translate([0,0,-NOTHING]) cylinder(r=pin_r_from_center - lock_pin_slot_t/2, h= square_depth + 3*NOTHING);
                // At this point we have a ring shape (cylinder minus a smaller cylinder), and we want to get rid of most of that ring so that only an arc remains.
                translate([0,0,-NOTHING]) linear_extrude(height=square_depth + 3*NOTHING) {
                    // Bounding shape to subtract all of the ring that is not part of the arc shape that we want.
                    // This bounding shape is a square with sides larger than the diameter of the ring, and it has a wedge cut out of it where the ring should remain.
                    polygon(points=[
                        [0,0], // Center of the square/circle; vertex of the wedge
                        polar_y_to_cartesian(180, 2*pin_r_from_center),
                        [2*pin_r_from_center, -2*pin_r_from_center],
                        [2*pin_r_from_center, 2*pin_r_from_center],
                        [-2*pin_r_from_center, 2*pin_r_from_center],
                        polar_y_to_cartesian(180+total_angle, 2*pin_r_from_center)
                    ]);
                }
            }
        }

    }
}

module wafer_shim() {
        rotate([-90, 0, 0]) translate([0, -wafer_slot_diameter/2, 0 ]) difference() {
            translate([-wafer_slot_width/2, 0, 0]) cube([wafer_slot_width, wafer_slot_diameter/2, wafer_slot_depth]);
            translate([0,0,-NOTHING]) cylinder(d=tumbler_diameter, h=wafer_slot_depth+2*NOTHING);
        }
}

module lock_spacer() {
    difference() {
        cylinder(d=frame_d, h=lock_spacer_t);
        translate([0,0,-NOTHING]) intersection() {
            cylinder(d=lock_body_diameter, h=lock_spacer_t + 2*NOTHING);
            translate([-lock_body_flat_diameter/2, -lock_body_diameter/2-NOTHING, 0]) cube([lock_body_flat_diameter, lock_body_diameter + 2*NOTHING, lock_spacer_t + 2*NOTHING]);
        }
    }
}

// frame(spacer=true);
// translate([frame_t + 5, 0, center_from_floor]) rotate([0,90,0]) rotate([0,0,-90 + start_key_angle_from_center]) coupler();
coupler();

// wafer_shim();
