include <flap_params.scad>;

module bracket() {
    difference() {
        cube([bracket_x,bracket_y, bracket_depth]);
        translate([bracket_wall_t, bracket_wall_t, -NOTHING]) cube([bracket_x - 2*bracket_wall_t, bracket_y-bracket_wall_t+NOTHING, bracket_depth+2*NOTHING]);
        let (hole_spacing = (bracket_y -2*bracket_wall_t)/(n_holes-1)) {
            for (i= [0:n_holes-1]) {
                translate([-NOTHING,hole_from_top + i*hole_spacing, bracket_depth/2]) rotate([0,90,0]) cylinder(d=hole_d, h=hole_depth + NOTHING);
                translate([bracket_x-hole_depth,hole_from_top + i*hole_spacing, bracket_depth/2]) rotate([0,90,0]) cylinder(d=hole_d, h=hole_depth + NOTHING);
            }
        }
    }
}

bracket();