// Ensure `bezel_config.scad` exists in the same directory as this file,
// or replace this `include` statement with the configurations it would contain.
include <bezel_config.scad>;

// Set this to true when to generate models that can be subtracted from material to
// create a void for the bezel.
AS_DIE=false;

// =====================================================
// =               PART CONSTRUCTION                   =
// =====================================================
// Enable one part at a time by uncommenting it (removing the "//")

// STANDARD BEZELS WITH OPTIONAL EXTERNAL POTENTIOMETERS
// main_bezel(num_pots=1, outer_diameter=LARGE_BEZEL_OUTER_DIAMETER);

// CUSTOM TACHOMETER (HALF INSTRUMENT)
// partial_bezel(32);

// CUSTOM BEZEL FOR DECONSTRUCTEDHONEYCOMB YOKE (SMALL GAUGE FORM FACTOR)
// honeycomb_bezel(split=true);

// INSTALLATION_AIDS (May take a few minutes to render)
// bezel_alignment_template();
// bezel_router_guide() cylinder(d=LARGE_BEZEL_OUTER_DIAMETER, h=guide_base_h);
// bezel_router_guide() cylinder(d=SMALL_BEZEL_OUTER_DIAMETER, h=guide_base_h);
// encoder_tab_router_guide();
// for custom tachometer:
// bezel_router_guide() partial_bezel(32, with_tabs=false, solid=true);


module screw_tab(r=screw_position_r, model_screws=AS_DIE) {
    translate([r, 0, 0]) difference() {
        union() {
            // TAB BACKSTOP
            cylinder(d=screw_tab_w, h=_tab_base_h);
            translate([-_tab_extension_l, -screw_tab_w/2, 0]) cube([_tab_extension_l, screw_tab_w, _tab_base_h]);
            // SOCKET
            translate([0,0,_tab_base_h]) cylinder(d=screw_socket_od, h=screw_socket_h);
            if (model_screws) {
                cylinder(d=screw_socket_id, h=total_h);
            }
        }
        if (!model_screws) {
            translate([0,0,tab_socket_backstop_h-NOTHING]) cylinder(d=screw_socket_id, h=_tab_base_h+screw_socket_h-tab_socket_backstop_h+2*NOTHING);
            translate([0,0,-NOTHING]) cylinder(d=tab_socket_backstop_hole_id, h=_tab_base_h+2*NOTHING);
        }
    }
}

module _outer_pot_tab(r) {
    rotate([0,0,-90]) translate([0, r, 0]) union() {
        translate([0, pot_tab_minor/2-pot_tab_fillet_r, 0]) hull() {
            translate([-pot_tab_major/2 + pot_tab_fillet_r, 0, 0]) cylinder(r=pot_tab_fillet_r, h=total_h);
            translate([pot_tab_major/2 - pot_tab_fillet_r, 0, 0]) cylinder(r=pot_tab_fillet_r, h=total_h);
        }
        translate([-pot_tab_major/2, -pot_tab_minor/2, 0]) cube([pot_tab_major, pot_tab_minor - pot_tab_fillet_r, total_h]);
    }
}

module outer_pot_tab(r=pot_position_r) {
    union() {
        _outer_pot_tab(r);
        minkowski() {
            linear_extrude(height=_tab_base_h/2) projection() _outer_pot_tab(r);
            cylinder(r=backstop_t, h=_tab_base_h/2);
        }
    }
}

module pot_cut(x=pot_major, y=pot_minor, z=pot_h, d=pot_shaft_hole_d) {
    // SENSOR SHAFT HOLE
    if (!MODEL_SUPPORT_FOR_HANGING_CIRCLES) {
        translate([0,0,-NOTHING]) cylinder(d=d, h=total_h+2*NOTHING);
    } else {
        translate([0,0,z+SUPPORT_LAYER_H]) cylinder(d=d, h=total_h-SUPPORT_LAYER_H+NOTHING);
    }
    // SENSOR CAVITY
    translate([-x/2, -y/2, -NOTHING]) cube([x, y, z]);
}

module outer_pot_cut(r=pot_position_r) {
    rotate([0,0,-90]) translate([0, r, 0]) union() {
        pot_cut();
        // WIRE CAVITY
        translate([-pot_tab_major/2-backstop_t-NOTHING, -pot_wire_cut_w/2, -NOTHING]) cube([pot_tab_major + 2*backstop_t + 2*NOTHING, pot_wire_cut_w, pot_wire_cut_h]);
    }
}

module outer_additions(num_pots=NUM_OUTER_POTS, outer_radius=_or, with_tabs=true, model_screws=AS_DIE) {
    rotate([0,0,-45]) union() {
        // POTS: 0, 1, or 2
        if (num_pots > 0) {
            for (i= [0 : num_pots-1]) {
                rotate([0,0,-90*i]) outer_pot_tab(r=outer_radius+pot_position_offset);
            }
        }
        if (with_tabs) {
            // SCREWS: remaining positions
            for (i= [num_pots : 3]) {
                rotate([0,0,-90*i]) screw_tab(r=outer_radius+screw_position_offset, model_screws=model_screws);
            }
        }
    }
}

module outer_cuts(num_pots=NUM_OUTER_POTS, outer_radius=_or) {
    rotate([0,0,-45]) union() {
        if (num_pots > 0) {
            for (i=[0 : num_pots - 1]) {
                rotate([0,0,-90*i]) outer_pot_cut(outer_radius+pot_position_offset);
            }
        }
    }
}

module bezel_chamfer_cut(chamfer_outer_diameter=bezel_od, chamfer_inner_diameter=id, has_flat=false, flat_from_center=0, flat_chamfer_depth=total_h) {
    _chamfer_offset=chamfer_outer_diameter-chamfer_inner_diameter;
    difference() {
        translate([0,0,-NOTHING]) cylinder(d1=chamfer_inner_diameter, d2=chamfer_outer_diameter, h=total_h+2*NOTHING);
        if (has_flat) {
            translate([0,-flat_from_center,total_h-flat_chamfer_depth]) union() {
                rotate([atan((_chamfer_offset/2)/flat_chamfer_depth),0,0]) translate([-chamfer_outer_diameter/2,-chamfer_outer_diameter,0]) cube([chamfer_outer_diameter, chamfer_outer_diameter, chamfer_outer_diameter]);
                translate([-chamfer_outer_diameter/2, -chamfer_outer_diameter, -total_h]) cube([chamfer_outer_diameter, chamfer_outer_diameter, total_h]);
            }
        }
    }
}

module main_bezel(
    outer_diameter=od,
    inner_diameter=id,
    chamfer_outer_diameter=bezel_od,
    num_pots=NUM_OUTER_POTS,
    with_tabs=true,
    as_die=AS_DIE,
    solid=AS_DIE,
    center_fill=false,
    fill_from_center=0,
    center_chamfer_depth=2,
    center_sensor=false,
) {
    outer_pot_r=outer_diameter+pot_position_offset;
    outer_radius=outer_diameter/2;
    difference() {
        union() {
            cylinder(d=outer_diameter, h=total_h);
            cylinder(d=outer_diameter+2*backstop_t, h=_tab_base_h);
            outer_additions(num_pots=num_pots, outer_radius=outer_radius, with_tabs=with_tabs, model_screws=as_die);
        }
        if (!solid && !as_die) {
            if (center_fill) {
                bezel_chamfer_cut(chamfer_outer_diameter=chamfer_outer_diameter, chamfer_inner_diameter=inner_diameter, has_flat=true, flat_from_center=fill_from_center, flat_chamfer_depth=center_chamfer_depth);
                if (center_sensor) {
                    translate([0,-fill_from_center - (outer_radius-fill_from_center)/2,0]) union() {
                        children();
                    }
                }
            } else {
                bezel_chamfer_cut(chamfer_outer_diameter=chamfer_outer_diameter, chamfer_inner_diameter=inner_diameter);
            }
            outer_cuts(num_pots=num_pots, outer_radius=outer_radius);
        }
    }
}

module partial_bezel(visible_to_cut=id, chamfer_depth=total_h, with_tabs=true, solid=false, num_pots=0 ) {
    bottom_tab_major=10;
    bottom_tab_minor=5;
    union() {
        difference() {
            union() {
                cylinder(d=od, h=total_h);
                outer_additions(with_tabs);

            }
            if (!solid) {
                bezel_chamfer_cut(has_flat=true, flat_from_center=visible_to_cut-id/2, flat_chamfer_depth=chamfer_depth);
                outer_cuts();
            }
            translate([-od,
            -2*od-(visible_to_cut-id/2)
            -_bezel_offset*chamfer_depth/total_h-_top_t, -NOTHING]) cube([2*od, 2*od, total_h+2*NOTHING]);
        }
        if (with_tabs) {
            translate([-bottom_tab_major/2,
                -bottom_tab_minor-(visible_to_cut-id/2)
                -_bezel_offset*chamfer_depth/total_h-_top_t, 0]) cube([bottom_tab_major,bottom_tab_minor, _tab_base_h]);
        }
    }
}

module fillet_90(r=1, h=10, a=0) {
    rotate([0,0,a+180]) translate([-r, -r, 0]) difference() {
        cube([r, r, h]);
        cylinder(r=r, h=h);
    }
}

module clock_profile() {
    fillet_r=0.5;
    lower_w=45.5;
    lower_h=16.8;
    upper_w=41.3;
    upper_h=26.9-lower_h;
    _z=1;
    base_from_center=16.9-28.5;
    projection() {
        difference() {
            union() {
                translate([-lower_w/2, base_from_center, 0]) cube([lower_w, lower_h,_z]);
                translate([-upper_w/2, base_from_center+lower_h, 0]) cube([upper_w, upper_h,_z]);
                translate([-upper_w/2, base_from_center+lower_h, 0]) fillet_90(r=fillet_r, h=_z, a=90);
                translate([upper_w/2, base_from_center+lower_h, 0]) fillet_90(r=fillet_r, h=_z, a=0);
            }
            translate([-upper_w/2, base_from_center+lower_h+upper_h, 0]) fillet_90(r=fillet_r, h=_z, a=270);
            translate([upper_w/2, base_from_center+lower_h+upper_h, 0]) fillet_90(r=fillet_r, h=_z, a=180);
            translate([-lower_w/2, base_from_center+lower_h, 0]) fillet_90(r=fillet_r, h=_z, a=270);
            translate([lower_w/2, base_from_center+lower_h, 0]) fillet_90(r=fillet_r, h=_z, a=180);
            translate([-lower_w/2, base_from_center, 0]) fillet_90(r=fillet_r, h=_z, a=0);
            translate([lower_w/2, base_from_center, 0]) fillet_90(r=fillet_r, h=_z, a=90);
        }
    }
}

module clock_cut() {
    linear_extrude(height=total_h, scale=1+_bezel_offset/_or) clock_profile();
}

module clock_bezel() {
    button_position_r=_or-6;
    button_angles=[0,155,205];
    difference() {
        union() {
            cylinder(d=od, h=total_h);
            outer_additions();
        }
        clock_cut()
        outer_cuts();
        for (a = button_angles) {
            rotate([0,0,a]) translate([0, button_position_r, 0]) union() {
                pot_cut();
                translate([-pot_major/2, pot_minor/2, 0]) cube([pot_major, _or-button_position_r, _tab_base_h]);
            }
        }
    }
}

router_guide_d=60.34;
bit_d=3.2;
router_offset_r=(router_guide_d-bit_d)/2;
module router_offset(h=5) {
    minkowski() {
        linear_extrude(height=h) projection(cut=false) children(0);
        cylinder(r=router_offset_r, h=h);
    }
}
fence_t=5;
module router_fence(fence_h=3, solid=false) {
    difference() {
        minkowski() {
            router_offset(fence_h/2) children(0);
            cylinder(r=fence_t, h=fence_h/2);
        }
        if (!solid) {
            translate([0,0,-NOTHING]) router_offset(fence_h+2*NOTHING) children(0);
        }
    }
}

//  router_fence() outer_pot_tab();
//  color("orange") router_offset() outer_pot_tab();
//  color("white") translate([0,0,5]) outer_pot_tab();

guide_base_h=4;
guide_r=5;
etch_depth=0.25;
countersink_h=3.5;
countersink_d=6;

module router_guide_screw_countersink_cut(hole_d=screw_socket_id, countersink_d=countersink_d, countersink_depth=countersink_h, material_thickness=guide_base_h) {
    translate([0,0,material_thickness-countersink_depth]) cylinder(d=countersink_d, h=countersink_depth+NOTHING);
    translate([0,0,-NOTHING]) cylinder(d=hole_d, h=material_thickness-countersink_depth+2*NOTHING);
}

module encoder_tab_router_guide() {
    difference() {
        union() {
            color("purple") hull() {
                translate([0,screw_position_r, 0]) cylinder(r=guide_r,h=guide_base_h);
                translate([0,-screw_position_r, 0]) cylinder(r=guide_r,h=guide_base_h);
                translate([screw_position_r, 0, 0]) cylinder(r=guide_r,h=guide_base_h);
            }

            // router_fence() outer_pot_tab();
            color("purple") minkowski() {
                linear_extrude(height=guide_base_h/2) projection() outer_pot_tab();
                cylinder(r=guide_r+fence_t+router_offset_r, h=guide_base_h/2);
            }
            translate([0,0,guide_base_h]) router_fence() outer_pot_tab();
        }
        outer_pot_tab();
        translate([0,0, guide_base_h-etch_depth]) difference() {
            cylinder(d=od, h=etch_depth);
            cylinder(d=id, h=etch_depth);
        }
        translate([0,screw_position_r, 0]) router_guide_screw_countersink_cut();
        translate([0,-screw_position_r, 0]) router_guide_screw_countersink_cut();
        translate([od/3,0, 0]) router_guide_screw_countersink_cut();
        translate([0,0, guide_base_h-etch_depth]) linear_extrude(height=etch_depth+NOTHING) text("2", valign="center", halign="center");
    }
}

module bezel_router_guide() {
    difference() {
        union() {
            color("purple") minkowski() {
                linear_extrude(height=guide_base_h/2) projection() children(0);
                cylinder(r=guide_r+fence_t+router_offset_r, h=guide_base_h/2);
            }
            translate([0,0, guide_base_h]) router_fence() children(0);
        }
        children(0);
        for (a = [45 : 90 : 315]) {
            rotate([0,0,a]) translate([screw_position_r, 0, 0]) router_guide_screw_countersink_cut();
        }
        translate([screw_position_r + 10,0,guide_base_h-etch_depth]) linear_extrude(height=etch_depth+NOTHING) text("3", valign="center", halign="center");
    }
}

alignment_base_h=1;

module bezel_alignment_template(bezel_diameters=[LARGE_BEZEL_OUTER_DIAMETER, SMALL_BEZEL_OUTER_DIAMETER], drill_hole_d=screw_socket_id) {
    plate_r=bezel_diameters[0]/2+screw_position_offset + screw_tab_w/2 + guide_r;
    window_major=plate_r/2;
    window_minor=window_major/3;
    height_with_etches=alignment_base_h+len(bezel_diameters*etch_depth);
    difference() {
        union() {
            cylinder(r=plate_r, h=alignment_base_h);
            for (i= [0 : 1 : len(bezel_diameters) - 1]) {
                translate([0, 0, alignment_base_h]) intersection() {
                    main_bezel(outer_diameter=bezel_diameters[i], chamfer_outer_diameter=bezel_diameters[i], inner_diameter=bezel_diameters[i]-3, num_pots=0);
                    cylinder(r=plate_r, h=(i+1)*etch_depth);
                }
            }
        }
        for (d=bezel_diameters) {
            for (a=[45:90:315]) {
                rotate([0,0,a]) translate([d/2+screw_position_offset, 0, -NOTHING]) cylinder(d=drill_hole_d, h=height_with_etches+2*NOTHING);
            }
        }
        for (a = [0 : 90 : 270]) rotate([0,0,a]) {
            translate([plate_r-1.5, 0, -NOTHING]) rotate([0,0,-45]) cube([4,4,alignment_base_h + 2*NOTHING]);
            translate([plate_r/2, 0, -NOTHING]) linear_extrude(height=alignment_base_h+len(bezel_diameters)*etch_depth + 2*NOTHING, scale=1.5) polygon(points=[
                [-window_major/2,0], [0, -window_minor/2], [window_major/2, 0], [0, window_minor/2]
            ]);
        }
        translate([0,0,-NOTHING]) cylinder(d1=1, d2=3, h=alignment_base_h+2*NOTHING);
        rotate([0,0,22.5]) translate([bezel_diameters[0]/2+screw_position_offset, 0, alignment_base_h-etch_depth]) rotate([0,0,-22.5]) linear_extrude(height=etch_depth+NOTHING) text("1", valign="center", halign="center");
    }

}

// HONEYCOMB ALPHA BEZEL
module honeycomb_bezel(split=true) {
    if (split) {
        //BOTTOM PORTION
        translate([0,-1,0]) difference() {
            honeycomb_bezel(split=false);
            translate([-SMALL_BEZEL_OUTER_DIAMETER, 0, -NOTHING]) cube([
            2*SMALL_BEZEL_OUTER_DIAMETER,
            SMALL_BEZEL_OUTER_DIAMETER,
            total_h + 2*NOTHING]);
        }
        // TOP PORTION
        translate([0,1,0]) difference() {
            honeycomb_bezel(split=false);
            translate([-SMALL_BEZEL_OUTER_DIAMETER, -SMALL_BEZEL_OUTER_DIAMETER, -NOTHING]) cube([
            2*SMALL_BEZEL_OUTER_DIAMETER,
            SMALL_BEZEL_OUTER_DIAMETER,
            total_h + 2*NOTHING]);
        }
    } else {
        rotate([0,0,180]) main_bezel(
            outer_diameter=SMALL_BEZEL_OUTER_DIAMETER,
            inner_diameter=YOKE_BEZEL_INNER_DIAMETER,
            chamfer_outer_diameter=SMALL_BEZEL_OUTER_DIAMETER-2*_FLAT_WIDTH,
            center_fill=true,
            fill_from_center=YOKE_FLAT_FROM_CENTER,
            center_chamfer_depth=total_h,
            center_sensor=false
        );
    }
}

module radius_cube(size, r) {
    x = size[0];
    y = size[1];
    z = size[2];
    d=2*r;
    union() {
        translate([r, r, 0]) cylinder(r=r, h=z);
        translate([x - r, r, 0]) cylinder(r=r, h=z);
        translate([r, y-r, 0]) cylinder(r=r, h=z);
        translate([x - r, y-r, 0]) cylinder(r=r, h=z);
        translate([r, 0, 0]) cube([x-d, y, z]);
        translate([0, r, 0]) cube([x, y-d, z]);
    }
}


module annunciator(view_w, view_h, wall_t, outer_r, button_area_w=15) {
    annunc_w=2*wall_t + view_w + button_area_w;
    annunc_h=2*wall_t + view_h;
    difference() {
        union() {
            // BEZEL BODY
            radius_cube([annunc_w, annunc_h, total_h], outer_r);        
            // BACKSTOP
            translate([-backstop_t, -backstop_t, 0]) radius_cube([annunc_w+2*backstop_t, annunc_h+2*backstop_t, _tab_base_h], outer_r+backstop_t);
            translate([annunc_w, annunc_h/2, 0]) screw_tab(screw_position_offset);    
            translate([0, annunc_h/2, 0]) rotate([0,0,180]) screw_tab(screw_position_offset);    
        }
        // VIEW AREA
        translate([wall_t, wall_t, -NOTHING]) radius_cube([view_w, view_h, total_h + 2*NOTHING], outer_r - wall_t);
        // RECESS FOR SWITCH/BUTTON & WIRES
        translate([annunc_w - button_area_w/2, annunc_h/2, 0]) children();
    }
}


module tactile_button_wires(x, y, wire_cut_w, backplate_offset=2, backplate_h=1) {
    union() {
        translate([-x/2, -wire_cut_w/2, -NOTHING]) cube([x, wire_cut_w, _tab_base_h+NOTHING]);
        translate([-x/2 - backplate_offset, -y/2, -NOTHING]) cube([x + 2*backplate_offset, y, backplate_h+NOTHING]);
        children();
    }
}
