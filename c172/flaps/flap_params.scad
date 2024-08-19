include <../frame_lib.scad>;

CLEARANCE_FIT=0.5;
NOTHING = 0.01;

proj_facade_h=119;
proj_h_from_floor=46;
proj_h_from_desk=58;
proj_desk_h=0.75*25.4;

proj_facade_d=5;
proj_frame_d=12;
proj_desk_gap_d=7;

flap_material_t= 3/16*25.4; // ~4mm
flap_plate_t=2.1;
flap_plate_r=3.4;

flap_body_w=50.5;
flap_body_h=68.8;
flap_body_d=90;

// Dimensions vertical from bottom of flap_body_h
flap_side_hole_1=11.5;
flap_side_hole_2=flap_body_h/2;
flap_side_hole_3=flap_body_h-flap_side_hole_1;
flap_side_hole_d=2.1;

// left side
flap_bracket_x1=6;
// right side
flap_bracket_x2=8.5;
// bottom
flap_bracket_y1=6.5;
// top
flap_bracket_y2=flap_bracket_y1;

flap_offset_from_desk=-13;

lever_from_left=26.0;
lever_from_bottom=24.5;
lever_from_front=60;
flap_pot_hole_d=7.5;
flap_pot_tab_r_from_center=8;
flap_pot_tab_w=3;

needle_w=2.8;
needle_from_left=16.4;
needle_from_front=60;
needle_from_bottom=12.8 + lever_from_bottom;
servo_w1=23;
servo_w2=12;
servo_from_center_1=7;
servo_from_center_2=servo_w2/2;
servo_screw_slot_w1=4.5;
servo_screw_slot_w2=1.5;

_frame_cut_clearance=1;
frame_cut_w=flap_body_w+2*_frame_cut_clearance;
frame_cut_h=flap_body_h+2*_frame_cut_clearance;
frame_cut_d=flap_body_d+2*_frame_cut_clearance;


proj_view_neg_x=0;
// proj_view_pos_x=100;
proj_view_pos_x=frame_cut_w/2;

proj_view_w=proj_view_pos_x+proj_view_neg_x;
proj_view_h=200;
proj_view_d=200;

lever_slot_top_from_axis=34;
needle_slot_clearance=0.4;
// match flap_lever.scad
_needle_w=2.8;

needle_slot_w=_needle_w+2*needle_slot_clearance;

bracket_x=30;
bracket_y=53;
bracket_wall_t=5;
bracket_depth=8;
bracket_offset_x=needle_from_left-needle_slot_clearance- bracket_wall_t;
bracket_offset_y=lever_from_bottom+lever_slot_top_from_axis-bracket_y+needle_slot_w/2;

n_holes=3;
hole_d=2.4;
bracket_thru_hole_d=3.1;
hole_depth=4.5;
hole_from_top=5.5;

$fn=100;