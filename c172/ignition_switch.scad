total_angle=120;
start_key_angle_from_center=-total_angle/2;
lock_flat_angle_from_key=0;

lock_body_diameter=20;
wafer_slot_diameter=15.0;
wafer_slot_width=6;
tumbler_diameter=12.5;
wafer_slot_depth=26.4-2.6;

tumbler_square_width=8.6;
tumbler_square_offset_from_key=0;
square_depth=2.2;
lock_screw_depth=2.2;
lock_nut_relief_d=27;
lock_nut_relief_w=7;
lock_body_clamp_hole_d=3;
lock_body_clamp_hole_h=7.5;
lock_body_clamp_hole_from_center=12;
access_hole_d=6;

pin_angle_from_start=0;

connector_length=20.8;

screw_head_diameter=12;
screw_d=6.8;
screw_head_t=4;

frame_t=4;
center_from_floor=17;
frame_d=33;
frame_length=45.7;

switch_d=10;
switch_d2=12;
switch_d2_t=0.75;
switch_locator_d=3.8;
switch_locator_from_center=11.7;

spring_hole_diam=2.6;
spring_hole_depth=(frame_d-lock_body_diameter)/2-0.75;
num_spring_holes=6;
spring_hole_angle_between=90/num_spring_holes;
spring_hole_first_angle=0;

NOTHING=0.1;
$fn=100;

module frame() {
    difference() {
        union() {
            translate([0,0,center_from_floor]) rotate([0,90,0]) cylinder(d=frame_d, h=frame_length);
            translate([0,-frame_d/2, 0]) cube([frame_length, frame_d, center_from_floor]);
        }
        // CUT OFF ANY EXTRA CYLINDER
        translate([-NOTHING,-frame_d/2-NOTHING,-frame_d-NOTHING]) cube([frame_length+2*NOTHING, frame_d+2*NOTHING, frame_d+NOTHING]);
        // MAIN BODY CUT
        translate([frame_t, -frame_d/2-NOTHING, frame_t]) cube([frame_length - 2*frame_t, frame_d + 2*NOTHING, frame_d/2 + center_from_floor+NOTHING]);
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
            rotate([i*spring_hole_angle_between + spring_hole_first_angle, 0, 0]) translate([frame_t/2, 0, frame_d/2 - spring_hole_depth]) cylinder(d=spring_hole_diam, h=spring_hole_depth);
            rotate([i*spring_hole_angle_between + spring_hole_first_angle, 0, 0]) translate([frame_length - frame_t/2, 0, frame_d/2 - spring_hole_depth]) cylinder(d=spring_hole_diam, h=spring_hole_depth);
        }
    }
}

frame();