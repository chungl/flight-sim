NUM_OUTER_POTS=2;

id=36.25*2;
bezel_od=39.5*2;
_or=40.25;
od=_or*2;

// Total bezel height is divided into three regions: Tab (sits behind the panel), Embeded (in the panel), and Raised (above the panel).
panel_thickness=5.3; // Thickness of the panel material (the Embeded portion of the bezel)
bezel_height_above_panel=0; // For flush bezel, set this to 0.

screw_position_r=45;
screw_tab_w=10;
screw_socket_od=3.15*2;
screw_socket_id=1.5*2;
screw_socket_h=3;
tab_socket_backstop_h=0.75; // Thickness of the "bottom" of the screw socket, or 0 to disable.
tab_socket_backstop_hole_id=1; //.8*2; // Diameter of a smaller hole in the bottom of the socket, or 0 for none.

pot_h=7;
pot_shaft_hole_d=7.3;
pot_major=13;
pot_minor=12.5;
pot_position_r=screw_position_r + 1;
pot_tab_major=25;
pot_tab_fillet_r=4.675;
_pot_tab_circle_overlap=_or - sqrt(pow(_or,2)-pow((pot_tab_major/2),2)); // Arc height as fn of chord length and radius
pot_tab_minor= 2*(pot_position_r - _or + _pot_tab_circle_overlap);
pot_wire_cut_w=8.5;
pot_wire_cut_h=2.5;
total_h=pot_h + 1;

_tab_base_h=total_h-panel_thickness-bezel_height_above_panel;
_tab_extension_l=screw_position_r-id/2;

MODEL_SUPPORT_FOR_HANGING_CIRCLES=true;
SUPPORT_LAYER_H=0.25;

NOTHING=0.1;

$fn=360;

module screw_tab() {
    translate([screw_position_r, 0, 0]) difference() {
        union() {
            cylinder(d=screw_tab_w, h=_tab_base_h);
            translate([-_tab_extension_l, -screw_tab_w/2, 0]) cube([_tab_extension_l, screw_tab_w, _tab_base_h]);
            translate([0,0,_tab_base_h]) cylinder(d=screw_socket_od, h=screw_socket_h);
        }
        translate([0,0,tab_socket_backstop_h-NOTHING]) cylinder(d=screw_socket_id, h=_tab_base_h+screw_socket_h-tab_socket_backstop_h+2*NOTHING);
        translate([0,0,-NOTHING]) cylinder(d=tab_socket_backstop_hole_id, h=_tab_base_h+2*NOTHING);
    }
}

module outer_pot_tab() {
    rotate([0,0,-90]) translate([0, pot_position_r, 0]) union() {
        translate([0, pot_tab_minor/2-pot_tab_fillet_r, 0]) hull() {
            translate([-pot_tab_major/2 + pot_tab_fillet_r, 0, 0]) cylinder(r=pot_tab_fillet_r, h=total_h);
            translate([pot_tab_major/2 - pot_tab_fillet_r, 0, 0]) cylinder(r=pot_tab_fillet_r, h=total_h);
        }
        translate([-pot_tab_major/2, -pot_tab_minor/2, 0]) cube([pot_tab_major, pot_tab_minor - pot_tab_fillet_r, total_h]);
    }
}

module outer_pot_cut() {
    rotate([0,0,-90]) translate([0, pot_position_r, 0]) union() {
        // SENSOR SHAFT HOLE
        if (!MODEL_SUPPORT_FOR_HANGING_CIRCLES) {
            translate([0,0,-NOTHING]) cylinder(d=pot_shaft_hole_d, h=total_h+2*NOTHING);
        } else {
            translate([0,0,pot_h+SUPPORT_LAYER_H]) cylinder(d=pot_shaft_hole_d, h=total_h-SUPPORT_LAYER_H+NOTHING);
        }
        // SENSOR CAVITY
        translate([-pot_major/2, -pot_minor/2, -NOTHING]) cube([pot_major, pot_minor, pot_h]);
        // WIRE CAVITY
        translate([-pot_tab_major/2-NOTHING, -pot_wire_cut_w/2, -NOTHING]) cube([pot_tab_major + 2*NOTHING, pot_wire_cut_w, pot_wire_cut_h]);
    }
}

module outer_additions() {
    rotate([0,0,-45]) union() {
        // POTS: 0, 1, or 2
        if (NUM_OUTER_POTS > 0) {
            for (i= [0 : NUM_OUTER_POTS-1]) {
                rotate([0,0,-90*i]) outer_pot_tab();
            }
        }
        // SCREWS: remaining positions
        for (i= [NUM_OUTER_POTS : 3]) {
            rotate([0,0,-90*i]) screw_tab();
        }
    }
}

module outer_cuts() {
    rotate([0,0,-45]) union() {
        if (NUM_OUTER_POTS > 0) {
            for (i=[0 : NUM_OUTER_POTS - 1]) {
                rotate([0,0,-90*i]) outer_pot_cut();
            }
        }
    }
}

difference() {
    union() {
        cylinder(d=od, h=total_h);
        outer_additions();
    }
    translate([0,0,-NOTHING]) cylinder(d1=id, d2=bezel_od, h=total_h+2*NOTHING);
    outer_cuts();
}
