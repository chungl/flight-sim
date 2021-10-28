NUM_OUTER_POTS=0;

id=24.5*2;
bezel_od=27.75*2;
_or=28.5;
od=_or*2;

// Total bezel height is divided into three regions: Tab (sits behind the panel), Embeded (in the panel), and Raised (above the panel).
panel_thickness=5.3; // Thickness of the panel material (the Embeded portion of the bezel)
bezel_height_above_panel=0; // For flush bezel, set this to 0.

screw_position_r=_or+4.75;
screw_tab_w=10;
screw_socket_od=3.15*2;
screw_socket_id=1.5*2;
screw_socket_h=3;
tab_socket_backstop_h=0.75; // Thickness of the "bottom" of the screw socket, or 0 to disable.
tab_socket_backstop_hole_id=1; //.8*2; // Diameter of a smaller hole in the bottom of the socket, or 0 for none.

pot_h=7;
pot_shaft_hole_d=7.2;
pot_major=13.5;
pot_minor=11;
pot_position_r=screw_position_r + 1;
pot_tab_major=25;
pot_tab_fillet_r=4.675;
_pot_tab_circle_overlap=_or - sqrt(pow(_or,2)-pow((pot_tab_major/2),2)); // Arc height as fn of chord length and radius
pot_tab_minor= 2*(pot_position_r - _or + _pot_tab_circle_overlap);
pot_wire_cut_w=8.5;
pot_wire_cut_h=2.5;
total_h=pot_h + 1;

HAS_ATTITUDE=true;
attitude_flat_distance_from_center=14.7;
attitude_tab_minor=3;
attitude_tab_major=18;

_bezel_offset=(bezel_od-id)/2;
_top_t=(od-bezel_od)/2;

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

module pot_cut() {
    // SENSOR SHAFT HOLE
    if (!MODEL_SUPPORT_FOR_HANGING_CIRCLES) {
        translate([0,0,-NOTHING]) cylinder(d=pot_shaft_hole_d, h=total_h+2*NOTHING);
    } else {
        translate([0,0,pot_h+SUPPORT_LAYER_H]) cylinder(d=pot_shaft_hole_d, h=total_h-SUPPORT_LAYER_H+NOTHING);
    }
    // SENSOR CAVITY
    translate([-pot_major/2, -pot_minor/2, -NOTHING]) cube([pot_major, pot_minor, pot_h]);
}

module outer_pot_cut() {
    rotate([0,0,-90]) translate([0, pot_position_r, 0]) union() {
        pot_cut();
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

module bezel_chamfer_cut(has_flat=false, flat_from_center=0, flat_chamfer_depth=total_h) {
    difference() {
        translate([0,0,-NOTHING]) cylinder(d1=id, d2=bezel_od, h=total_h+2*NOTHING);
        if (has_flat) {
            translate([0,-flat_from_center,total_h-flat_chamfer_depth]) union() {
                rotate([atan((_bezel_offset)/total_h),0,0]) translate([-od/2,-od,0]) cube([od, od, od]);
                translate([-od/2, -od, -total_h]) cube([od, od, total_h]);
            }
        }
    }
}

attitude_pot_wire_cut_major=30;
attitude_pot_wire_cut_minor=pot_minor;

module main_bezel() {
    difference() {
        union() {
            cylinder(d=od, h=total_h);
            outer_additions();
            if (HAS_ATTITUDE) {
                intersection() {
                    difference() {
                        translate([0,-attitude_tab_minor, 0]) cylinder(d=od, h=_tab_base_h);
                        translate([0,0,-NOTHING]) cylinder(d=od, h=_tab_base_h+2*NOTHING);
                    }
                    translate([-attitude_tab_major/2, -od/2-attitude_tab_minor-NOTHING, -NOTHING]) cube([attitude_tab_major, attitude_tab_minor+od/2, _tab_base_h+2*NOTHING]);
                }
            }
        }
        if (HAS_ATTITUDE) {
            bezel_chamfer_cut(has_flat=true, flat_from_center=attitude_flat_distance_from_center, flat_chamfer_depth=2);
            translate([0,-attitude_flat_distance_from_center - (od/2-attitude_flat_distance_from_center)/2,0]) union() {
                pot_cut();
                translate([-attitude_pot_wire_cut_major/2, -attitude_pot_wire_cut_minor/2, -NOTHING]) cube([
                    attitude_pot_wire_cut_major,
                    attitude_pot_wire_cut_minor,
                    pot_wire_cut_h+NOTHING
                ]);
            }
        } else {
            bezel_chamfer_cut();
        }
        outer_cuts();
    }
}

module partial_bezel(visible_to_cut=id, chamfer_depth=total_h) {
    bottom_tab_major=10;
    bottom_tab_minor=5;
    union() {
        difference() {
            union() {
                cylinder(d=od, h=total_h);
                outer_additions();

            }
            bezel_chamfer_cut(has_flat=true, flat_from_center=visible_to_cut-id/2, flat_chamfer_depth=chamfer_depth);
            outer_cuts();
            translate([-od, 
            -2*od-(visible_to_cut-id/2)
            -_bezel_offset*chamfer_depth/total_h-_top_t, -NOTHING]) cube([2*od, 2*od, total_h+2*NOTHING]);
        }
        translate([-bottom_tab_major/2, 
            -bottom_tab_minor-(visible_to_cut-id/2)
            -_bezel_offset*chamfer_depth/total_h-_top_t, 0]) cube([bottom_tab_major,bottom_tab_minor, _tab_base_h]);
    }
}

// Custom Tachometer
// partial_bezel(32);
main_bezel();