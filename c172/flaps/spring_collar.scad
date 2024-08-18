include <flap_params.scad>;
include <flap_lever_params.scad>;
use <flap_lever.scad>;

collar_d = 10;
collar_h = 8.5+gymbalW;
collar_clearance=0.05;

NOTHING = 0.1;
$fn=60;

module shaft_collar() {
    rotate([0,0, -handleA]) difference() {
        cylinder(d=collar_d-collar_clearance, h=collar_h, $fn=6);
        translate([0,0,collar_h-gymbalW]) hinge_pin_cut();
    }
}

module spring_collar() {
    difference() {
        union() {
            shaft_collar();
            spring_plate();
            knurledPotKey(h=collar_h);

        }
        difference() {
            translate([0,0,-NOTHING]) cylinder(r=encoderR, h=collar_h + 2*NOTHING);
            knurledPotKey(h=collar_h+2*NOTHING);
        }

    }
}

// rotate([-90,0,0]) {
//     color("teal") {
//         translate([0,0,-gymbalW]) {
//             // rotate([0,0,-handleA]) flap_lever();
//             mirror_lever();
//             // rotate([0,0,180]) spring_plate();
//         }
//     }


//     translate([0,0,collar_h-gymbalW]) rotate([180, 0, -handleA]) spring_collar();
// }

spring_collar();