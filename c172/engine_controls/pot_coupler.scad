NOTHING=0.1;
$fn=100;
n=60;


MOVING_CLEARANCE=0.1;
// STRAW/SHAFT
straw_center_from_bottom=15;
straw_d=6;
straw_hole_depth=10;

// STRAW-SIDE COUPLER
retainer_d=3;
shaft_coupler_d=straw_d+retainer_d;
shaft_coupler_l=20;


// POT-SIDE COUPLER
pot_coupler_l=15;
pot_coupler_base_h=straw_center_from_bottom - shaft_coupler_d/2;
pot_coupler_upper_wall_t=retainer_d/2;
pot_coupler_w=shaft_coupler_d+2*pot_coupler_upper_wall_t+MOVING_CLEARANCE;

pot_coupler_upper_l=10;
pot_coupler_upper_h=shaft_coupler_d+retainer_d;


// POT TAB
pot_tab_w=9;
pot_tab_t=1.5;
pot_tab_h=10;


module shaft_coupler() {

    translate([-(shaft_coupler_l-straw_hole_depth)/2, 0, 0]) rotate([0,90,0]) {
        difference() {
            cylinder(d=shaft_coupler_d, h=shaft_coupler_l);
            translate([0,0,shaft_coupler_l-straw_hole_depth]) cylinder(d=straw_d, h=straw_hole_depth+NOTHING);
            for (i = [0 : n]) {
                rotate([0,0,360*i/n]) translate([shaft_coupler_d/2, 0, (shaft_coupler_l-straw_hole_depth)/2]) sphere(d=retainer_d);
            }
        }        

    }
}

module pot_coupler() {
    difference() {
        union() {
            // BASE
            translate([0, -pot_coupler_w/2, 0]) cube([pot_coupler_l, pot_coupler_w, pot_coupler_base_h]);
            
            // UPPER
            translate([0, 0, pot_coupler_base_h]) {
                // Lower Retaining Ring
                translate([0,0,shaft_coupler_d/2]) for(i=[0:n/2]) {
                    rotate([360*i/n]) translate([pot_coupler_l/2, -shaft_coupler_d/2-MOVING_CLEARANCE/2, 0]) sphere(d=retainer_d-MOVING_CLEARANCE);
                }

                translate([(pot_coupler_l-pot_coupler_upper_l)/2,0,shaft_coupler_d/2]) {
                    // Lower Filet
                    difference() {
                        // rotate([0, 90, 0]) cylinder(d=pot_coupler_w, h=pot_coupler_upper_l);
                        translate([0, -pot_coupler_w/2, -shaft_coupler_d/2]) cube([pot_coupler_upper_l, pot_coupler_w, shaft_coupler_d/2]);
                        translate([-NOTHING, 0, 0]) rotate([0,90,0]) cylinder(d=shaft_coupler_d+MOVING_CLEARANCE, h=pot_coupler_upper_l+2*NOTHING);
                        translate([-NOTHING,-pot_coupler_w/2-NOTHING,0]) cube([pot_coupler_upper_l+2*NOTHING, pot_coupler_w+2*NOTHING, pot_coupler_upper_h+NOTHING]);
                    }
                    
                    // Upper Ribs
                    upper_rib();
                    mirror([0,1,0]) upper_rib();
                }

            }
        }

        // RETAINER HOLE
        translate([pot_coupler_l/2,-pot_coupler_w/2-NOTHING,straw_center_from_bottom+shaft_coupler_d/2+MOVING_CLEARANCE/2]) rotate([-90, 0, 0]) cylinder(d=retainer_d, h=pot_coupler_w+2*NOTHING);

        // POT TAB
        translate([(pot_coupler_l-pot_tab_w)/2, -pot_tab_t/2, -NOTHING]) cube([pot_tab_w, pot_tab_t, pot_tab_h + NOTHING]);
    }

}

module upper_rib() {
    translate([0,pot_coupler_w/2 - pot_coupler_upper_wall_t ,0]) cube([pot_coupler_upper_l, pot_coupler_upper_wall_t ,pot_coupler_upper_h - shaft_coupler_d/2]);
    translate([pot_coupler_upper_l/2, pot_coupler_w/2 - pot_coupler_upper_wall_t, 0]) cylinder(d=retainer_d-MOVING_CLEARANCE, h=shaft_coupler_d/2 - retainer_d);
    translate([pot_coupler_upper_l/2, pot_coupler_w/2 - pot_coupler_upper_wall_t, shaft_coupler_d/2 - retainer_d]) sphere(d=retainer_d-MOVING_CLEARANCE);
}


// color("cyan") pot_coupler();
translate([pot_coupler_l/2,0,straw_center_from_bottom]) shaft_coupler();