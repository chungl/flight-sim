include <../bezel_config_3_in.scad>;
use <../bezel_lib.scad>;


attitude_flat_distance_from_center=14.7;

attitude_pot_wire_cut_major=30;
attitude_pot_wire_cut_minor=pot_minor;

attitude_indicator();

module attitude_indicator(as_die) {
    main_bezel(
        center_fill=true,
        center_sensor=true,
        fill_from_center=attitude_flat_distance_from_center,
        as_die=as_die
    ) {
        // CUTS FOR ENCODER AND WIRE ROUTING
        pot_cut();
        // CENTER WIRE AREA
        translate([-attitude_pot_wire_cut_major/2, -attitude_pot_wire_cut_minor/2, -NOTHING]) cube([
            attitude_pot_wire_cut_major,
            attitude_pot_wire_cut_minor,
            pot_wire_cut_h+NOTHING
        ]);
        // LEFT SIDE WIRE EXIT
        translate([attitude_pot_wire_cut_major/2,0,-NOTHING]) {
            rotate([0,0,180 + 22.5]) 
                translate([-attitude_pot_wire_cut_minor/2, 0]) 
                cube([attitude_pot_wire_cut_minor, od, pot_wire_cut_h+NOTHING]);
            cylinder(d=attitude_pot_wire_cut_minor, h=pot_wire_cut_h + NOTHING);
        }
        // RIGHT SIDE WIRE EXIT
        translate([-attitude_pot_wire_cut_major/2,0,-NOTHING]) {
            rotate([0,0,180 - 22.5]) 
                translate([-attitude_pot_wire_cut_minor/2, 0]) 
                cube([attitude_pot_wire_cut_minor, od, pot_wire_cut_h+NOTHING]);
            cylinder(d=attitude_pot_wire_cut_minor, h=pot_wire_cut_h + NOTHING);
        }
    };
}

// TEMPLATE TOOL; NOT INTENDED FOR SIM USE
module ai_profile_with_tabs() {
    main_bezel(
        center_fill=true,
        center_sensor=true,
        fill_from_center=attitude_flat_distance_from_center,
        center_chamfer_depth=0,
        chamfer_outer_diameter=id
    );
}
