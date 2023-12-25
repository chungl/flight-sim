use <flap_sides.scad>;
NOTHING = 0;
$fn=360;
projection() {
    flap_frame_side_pot();
    translate([100, 0, 0]) flap_frame_side_servo();
    translate([200, 0, 0]) frame_bracket();
}