rocker_cut_x = 18;
rocker_cut_y = 30;
switch_cut_d = 7;

num_switches = 7;

switch_gap = 0.75*25.4;
rocker_gap = switch_gap;

key_switch_cut_d = 17;
key_switch_gap = 30;
key_switch_text_w = 25;
key_switch_label_bracket_w = 50;

line_w = 0.25;
material_t = 1;

NOTHING = 0.1;

etch_depth = 0.25;
etch_extrusion_h = etch_depth + NOTHING;
cut_t = material_t + 2*NOTHING;

font = "Liberation Sans:style=Bold";
switch_text_voffset = 3;
rocker_text_voffset = 2;

text_size=2;
text_line_height=3;



$fn=60;

module line(p1, p2, t) {
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
lights_label_w = 10;
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
            translate([x_mid, switch_cut_d/2 + switch_text_voffset + text_line_height]) bracket_label(["LIGHTS"], w=num_switches*switch_gap, h=text_line_height,label_w=lights_label_w);
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

module key_switch() {
    cylinder(d=key_switch_cut_d, h=cut_t);
    etch() translate([0,10,0]) bracket_label(["MAGNETOS"], label_w=key_switch_text_w, w=key_switch_label_bracket_w, h=text_line_height);
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