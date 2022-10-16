include <../bezel_config.scad>;

magnet_t=1.75;
magnet_d=6.3;
magnet_offset=0.2;
inner_d=2;
NOTHING = 0.1;
$fn=100;

hold_w=8;
monitor_frame_t=0.50;

t=_tab_base_h-monitor_frame_t;
l=8;

bar_w=hold_w;



module magnet_test() {
    difference(){
        cube([l, hold_w, t]);
        translate([l/2, hold_w/2, magnet_offset]) cylinder(d=magnet_d, h=t-magnet_offset+NOTHING);
        translate([l/2, hold_w/2, -NOTHING]) cylinder(d=inner_d, h=magnet_offset+2*NOTHING);
    }
}

// magnet_test();

module magnet_bar(n=3) {
    difference() {
        hull() {
            cylinder(d=bar_w, h=t);
            translate([(n+1)*magnet_d, 0, 0]) cylinder(d=bar_w, h=t);
        }
        cylinder();
        translate([magnet_d, 0, -NOTHING]) {
            for (i = [0:n-1]) {
                translate([magnet_d*i, 0, magnet_offset+NOTHING]) cylinder(d=magnet_d, h=t-magnet_offset+2*NOTHING);
            }
        }
        cylinder(d1=2, d2=magnet_d, h=t+2*NOTHING);
        translate([(n+1)*magnet_d, 0, 0])cylinder(d1=2, d2=magnet_d, h=t+2*NOTHING);
        translate([0, -bar_w/4, t/2]) cube([(n+1)*magnet_d, bar_w/2, t/2+NOTHING]);
    }
}

magnet_bar();