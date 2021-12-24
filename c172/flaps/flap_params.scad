proj_facade_h=119;
proj_h_from_floor=46;
proj_h_from_desk=58;
proj_desk_h=0.75*25.4;

proj_facade_d=5;
proj_frame_d=12;
proj_desk_gap_d=7;

flap_body_w=50.5;
flap_body_h=70;
flap_body_d=70;

flap_bracket_x1=6;
flap_bracket_x2=8.5;
flap_bracket_y1=6.5;
flap_bracket_y2=flap_bracket_y1;

flap_offset_from_desk=-14;

lever_from_left=26.0;
lever_from_bottom=24.5;
lever_from_front=60;

needle_w=2.8;
needle_from_left=16.4;
needle_from_front=40;
needle_from_bottom=13.8 + lever_from_bottom;

_frame_cut_clearance=1;
frame_cut_w=flap_body_w+2*_frame_cut_clearance;
frame_cut_h=flap_body_h+2*_frame_cut_clearance;
frame_cut_d=flap_body_d+2*_frame_cut_clearance;


proj_view_neg_x=100;
// proj_view_pos_x=100;
proj_view_pos_x=frame_cut_w/2;

proj_view_w=proj_view_pos_x+proj_view_neg_x;
proj_view_h=200;
proj_view_d=200;