include <../bezel_config.scad>;
monitor_frame_t=0.45;
tab_mount_w=10;
tab_hold_w=10;
tab_w=tab_mount_w + tab_hold_w;
tab_t=_tab_base_h-monitor_frame_t;
hole_spacing=10;
n_holes=2;
tab_l=n_holes*hole_spacing;
hole_d1=3;
hole_d2=6;
magnet_d=6.3;
magnet_offset=0.3;


locator_d1=7;
locator_d2=tab_hold_w;

$fn=100;


module frame_tab() {
    difference() {
        cube([tab_l, tab_w, tab_t]);
        translate([hole_spacing/2, tab_mount_w/2, -NOTHING]) {
            for (i = [0:n_holes-1]) {
                translate([hole_spacing*i, 0, 0]) cylinder(d1=hole_d1, d2=hole_d2, h=tab_t + 2*NOTHING);
            }
            for( i= [1:n_holes-1]) {
                translate([hole_spacing*i - hole_spacing/2, tab_mount_w/2 + tab_hold_w/2, 0]) {
                    cylinder(d1=locator_d1, d2=locator_d2, h=tab_t+2*NOTHING);

                    translate([-hole_spacing,0,0]) difference() {
                        translate([0, 0, 0]) cube([2*hole_spacing, tab_mount_w/2, tab_t+2*NOTHING]);
                        translate([0,0,0]) cylinder(r1=hole_spacing-locator_d1/2, r2=hole_spacing-locator_d2/2, h=tab_t+2*NOTHING);
                        translate([2*hole_spacing,0,0]) cylinder(r1=hole_spacing-locator_d1/2, r2=hole_spacing-locator_d2/2, h=tab_t+2*NOTHING);
                    }

                }
            }
        }
        
    }
}

module bezel_tab() {
    difference() {
        cube([tab_l, tab_mount_w+2, tab_t]);
        translate([0, -tab_mount_w, 0]) frame_tab();
        translate([hole_spacing, tab_mount_w/2, magnet_offset]) {
            for (i = [0:n_holes-2]) {
                translate([hole_spacing*i, 0, 0]) cylinder(d=magnet_d, h=tab_t+2*NOTHING);
            }
        }

        if (n_holes > 2) {
            translate([3*hole_spacing/2, tab_mount_w, -NOTHING]) {
                translate([0, -1, 2]) cube([hole_spacing*(n_holes-3), 2, 2]);
                for (i = [0:n_holes - 3]) {
                    translate([hole_spacing*i, 0, 0]) {
                        cylinder(d1=1, d2=4, h=tab_t+2*NOTHING);
                        rotate([0,0,45]) translate([-1, -tab_mount_w/2, 2]) cube([2, tab_mount_w/2, 2]);
                        rotate([0,0,-45]) translate([-1, -tab_mount_w/2, 2]) cube([2, tab_mount_w/2, 2]);
                    }
                }
            }
        }
    }
}

bezel_tab();
// translate([0,-tab_mount_w - 2, 0]) frame_tab();
// frame_tab();
