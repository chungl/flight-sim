rocker_cut_x = 22.3;
rocker_cut_y = 36.3;
switch_cut_d = 6;

num_switches = 7;

switch_gap = 20.5;
rocker_gap = 16;

key_switch_cut_d = 20;
key_switch_gap = 30;
key_switch_text_w = 29;
key_switch_label_bracket_w = 40;

switch_angle = 120;

line_w = 0.75;
material_t = 1;

NOTHING = 0.1;

etch_depth = 0.25;
etch_extrusion_h = etch_depth + NOTHING;
cut_t = material_t + 2*NOTHING;

font = "Liberation Sans:style=Bold";
switch_text_voffset = 6;
rocker_text_voffset = 5;

text_size=3;
text_line_height=1.3*text_size;



$fn=60;

module line(p1, p2, t=line_w) {
    hull() {
        translate(p1) circle(d=t);
        translate(p2) circle(d=t);
    }
}

module multiline_text(strings, font=font, size=text_size, line_height=text_line_height, halign="center") {
  translate([0, line_height*(len(strings)-1)/2, 0])
    for (i = [0: len(strings) - 1]) {
        translate([0, -line_height * i, 0]) text(strings[i], font=font, size=size, valign="center", halign=halign);
    };
}

module vertical_text_array(strings, halign="left", draw_line=false, char_align_index=0) {
    let (
        line_height=1.3*text_size,
        h = line_height*len(strings), 
        x_offset = halign == "left" ? 0.75*text_size : -0.75*text_size
    ) {
        translate([0,-line_height*(len(strings)-1)/2 + char_align_index*line_height]) {
            translate([x_offset, 0]) multiline_text(strings, halign="center",line_height=line_height);
            if (draw_line) {
                line([0,h/2], [0, -h/2]);
            }
        }
    }   
}

module horizontal_text_array(string, font=font, size=text_size, valign="baseline", halign="center", h_offset=0, draw_line=false) {
    translate([h_offset,text_line_height/2]) text(string, font=font, size=size, valign="center", halign=halign);
}

module etch() {
  translate([0, 0, material_t - etch_depth]) linear_extrude(etch_extrusion_h) children();
}

module switch(upper_labels, lower_labels=[]) {
    cylinder(d=switch_cut_d, h=cut_t);
    etch() {
        translate([0,switch_text_voffset + switch_cut_d/2, 0]) multiline_text(upper_labels, font=font, halign="center", size=text_size, line_height=text_line_height);
        if (len(lower_labels)>0) {
            translate([0,-switch_text_voffset -switch_cut_d/2, 0]) multiline_text(lower_labels, font=font, halign="center", size=text_size, line_height=text_line_height);
        }
    } 
    children();
}

module bracket_label(labels,w,h,label_w) {
    multiline_text(labels);
    line([-w/2, -h], [-w/2, 0], line_w);
    line([-w/2, 0], [-label_w/2, 0], line_w);
    line([w/2, 0], [label_w/2, 0], line_w);
    line([w/2, -h], [w/2, 0], line_w);
}

switch_labels = ["BCN", "LAND", "TAXI", "NAV", "STROBE"];
lights_label_w = 19;
module lights() {
    let (
        num_switches = len(switch_labels),
        x1 = -switch_gap/2,
        x2=(num_switches-1)*switch_gap - x1,
        x_mid = (x2+x1)/2,
        y1=switch_cut_d/2 + switch_text_voffset + text_line_height/2,
        y2=y1+text_line_height+switch_text_voffset
    ) {
        for (i = [0 : num_switches - 1]) {
            translate([i*switch_gap, 0, 0]) switch([switch_labels[i]], ["OFF"]);
        }
        translate([(num_switches-1)*switch_gap, 0, 0]) children();
        etch() {
            // line([x1, y1], [x1, y2], line_w);
            // line([x1, y2], [x_mid-lights_label_w/2, y2], line_w);
            // line([x_mid+lights_label_w/2, y2], [x2, y2], line_w);
            // line([x2, y1], [x2, y2], line_w);
            // translate([switch_gap*(num_switches-1)/2, y2]) multiline_text(["LIGHTS"]);
            translate([x_mid, switch_cut_d/2 + switch_text_voffset + 1.5*text_line_height]) bracket_label(["LIGHTS"], w=num_switches*switch_gap, h=1.5*text_line_height,label_w=lights_label_w);
        };
    }
}

module rocker_switch_pair(upper_labels, lower_left_labels, lower_right_labels) {
    translate([0,-rocker_cut_y/2, 0]) cube([rocker_cut_x, rocker_cut_y, cut_t]);
    etch() {
        translate([rocker_cut_x/2, rocker_cut_y/2 + rocker_text_voffset]) multiline_text(upper_labels);
        translate([rocker_cut_x/4, -rocker_cut_y/2 - rocker_text_voffset]) multiline_text(lower_left_labels);
        translate([3*rocker_cut_x/4, -rocker_cut_y/2 - rocker_text_voffset]) multiline_text(lower_right_labels);
    }
    translate([rocker_cut_x,0,0]) children();
}

module box(w, h) {
    line([0,0], [w, 0]);
    line([w,0], [w, h]);
    line([w, h], [0, h]);
    line([0, 0], [0, h]);
}

module leader_line(w, h, a, r=0) {
    if (a< 0) {
        leader_line(w, h, a+360, r) children();
    } else if (a >= 360) {
        leader_line(w, h, a-360, r) children();
    } else {
        let (
            inner_x = r*sin(a),
            inner_y = r*cos(a),
            critical_angle = atan((w/2)/(h/2))
        ) {
            if (a < critical_angle) {
                line([inner_x, inner_y], [h/2*tan(a), h/2]);
                translate([h/2*tan(a), h/2]) children();
            } else if (a < (180 - critical_angle)) {
                line([inner_x, inner_y], [w/2, -w/2*tan(a-90)]);
                translate([w/2, -w/2*tan(a-90)]) children();
            } else if (a < (180 + critical_angle)) { 
                line([inner_x, inner_y], [-h/2*tan(a), -h/2]);
                translate([-h/2*tan(a), -h/2]) children();
            } else if (a < (360-critical_angle)){
                line([inner_x, inner_y], [-w/2, w/2*tan(a-270)]);
                translate([-w/2, w/2*tan(a-270)]) children();
            } else {
                line([inner_x, inner_y], [h/2*tan(a), h/2]);
                translate([h/2*tan(a), h/2]) children();
            }
        }
    }
}

// !union() {
//     for (i = [0:5:360]){
//         // echo(str("TEST: ", i));
//         leader_line(20,20,i,3);
//     }
// }

module rotary_leader_lines(total_angle, width, height, inner_radius=0, offset=0) {
    // translate([-width/2, -height/2]) box(width, height);
    let (
        inner_angle=total_angle/($children-1)
    ) {
        for (i = [0: $children - 1]) {
            leader_line(width,height,inner_angle*i + offset - total_angle/2, key_switch_cut_d/2 + 2) children(i);
        }
    }
}

keyswitch_labels = [
    
];
module key_switch() {
    cylinder(d=key_switch_cut_d, h=cut_t);
    etch() 
        rotary_leader_lines(total_angle=120, width=key_switch_label_bracket_w-1.5*text_line_height, height=key_switch_label_bracket_w-1.5*text_line_height) {
            vertical_text_array(["O","F","F"], halign="right"); 
            translate([0,0.3*text_line_height]) horizontal_text_array("R",h_offset=-.5);
            translate([0,0.3*text_line_height]) horizontal_text_array("L");
            translate([0,0.3*text_line_height]) horizontal_text_array("BOTH",halign="left", h_offset=-4); 
            vertical_text_array(["S","T","A","R","T"], halign="left");
        }
    etch() translate([0,key_switch_label_bracket_w/2+1.5*text_line_height,0]) bracket_label(["MAGNETOS"], label_w=key_switch_text_w, w=key_switch_label_bracket_w, h=1.5*text_line_height);
    translate([key_switch_cut_d, 0 ,0]) children();
}

module switch_panel() {
    translate([0,0,-NOTHING]) 
        key_switch();
        translate([key_switch_gap, 0, 0]) rocker_switch_pair(["MASTER"], ["ALT"], ["BAT"])
        translate([rocker_gap, 0, 0]) switch(["FUEL", "PUMP"], ["OFF"])
        translate([switch_gap, 0, 0]) lights() 
        translate([switch_gap, 0, 0]) switch(["PITOT","HEAT"], ["OFF"])
        translate([rocker_gap, 0, 0]) rocker_switch_pair(["AVIONICS"], ["BUS 1"], ["BUS 2"]);
}

projection() switch_panel();