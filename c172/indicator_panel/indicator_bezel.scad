board_x=90.2;
board_y=20.1;
mount_hole_d=2;
mount_hole_inset=mount_hole_d/2 + 0.8; // +-0.1
wire_relief_y=2;
wire_relief_z=4;

indicator_x=81.3/8;
indicator_y=5;
indicator_z=6.3; // +-0.1
indicator_wall=0.6;
indicator_cut_tolerance=2;

spacer_cut_z=2;
spacer_z=1.5;
spacer_wall=1.5;
spacer_r=1;
spacer_mask_w=1;
spacer_flare_y=1;

window_x=82;
window_y=14;
bezel_z=3.3;
bezel_inset=1.4;

shell_x=94;
shell_y=26;
super_z=3.9;
mount_inset=4;

NOTHING=0.01;

module single_indicator(show_wall=true) {
    union() {
        cube([indicator_x, indicator_y, indicator_z]);
        if(show_wall) {
            color("white") translate([indicator_wall, indicator_wall, NOTHING]) cube([indicator_x-2*indicator_wall, indicator_y-2*indicator_wall, indicator_z]);

        }
    }
}

module indicator_array(num_x=1,num_y=1, show_wall=true) {
    union() {
        for(i = [0 : num_x-1]) {
            for (j = [0 : num_y-1]) {
                translate([i*indicator_x, j*indicator_y, 0]) single_indicator(show_wall);
            }
        }
    }
}

module indicator_cut(num_x=1, num_y=1) {
    cube([num_x*indicator_x + indicator_cut_tolerance, num_y*indicator_y + indicator_cut_tolerance, indicator_z]);
}


module spacer() {
    num_x=8;
    num_y=2;
    clearance=0.5;
    outer_x=num_x*indicator_x + 2*spacer_wall + clearance;
    outer_y=num_y*indicator_y + 2*spacer_wall + clearance;
    outer_z=spacer_cut_z + spacer_z;
    windows=[[[0,3],[3, 1],[4,1],[5,1],[6,2]], [[0,1],[1, 3],[4,1],[5, 3]]];
    difference() {
        translate([-spacer_wall - clearance/2, -spacer_wall - clearance/2, -spacer_cut_z]) union() {
            difference() {
                color("blue") cube([outer_x, outer_y, outer_z]);
                color("orange") translate([spacer_wall, spacer_wall, -NOTHING]) cube([outer_x-2*spacer_wall, outer_y-2*spacer_wall,spacer_cut_z+NOTHING]);
            }
        }
        for (j = [0 : len(windows) - 1]) {
            cur_row=windows[j];
            for (i = [0 : len(cur_row) - 1]) {
                offset_blocks=cur_row[i][0];
                cur_window_blocks=cur_row[i][1];
                echo (j, i, offset_blocks, cur_window_blocks);
                cur_window_w=cur_window_blocks*indicator_x-spacer_mask_w;
                translate([offset_blocks*indicator_x + spacer_mask_w/2, j*indicator_y + spacer_mask_w/2, -NOTHING]) union() {
                    cube([cur_window_w, indicator_y-spacer_mask_w, spacer_z + 2*NOTHING]);
                    if (j % 2 == 1) {
                        translate([0, indicator_y-spacer_mask_w, 0]) rotate([90, 0, 90]) linear_extrude(height=cur_window_w) {
                            polygon(points=[[0,0], [spacer_flare_y, spacer_z+2*NOTHING], [0, spacer_z+2*NOTHING]]);
                        }
                    } else {
                        rotate([90, 0, 90]) linear_extrude(height=cur_window_w) {
                            polygon(points=[[0,0], [-spacer_flare_y, spacer_z+2*NOTHING], [0, spacer_z+2*NOTHING]]);
                        }
                    }
                }
            }
        }
    }
}


// module fillet_negative(r, rotate_z=0, a=90, h=1000, x=0, y=0, z=0, rotate_y=0, rotate_z=0) {
//     $fn=1000;
//     translate([x, y, z]) rotate([rotate_x, rotate_y, rotate_z]) intersection() {
//         translate([-r-NOTHING, -r-NOTHING, -NOTHING]) cube([2*(r+NOTHING), 2*(r+NOTHING), h+2*NOTHING]);
//         rotate_extrude(angle=a) {
//             translate([r, 0, -NOTHING]) square([r+NOTHING, h+2*NOTHING]);
//         }
//     }
// }

// indicator_array(8,2, true);
// indicator_cut(8,2);

// fillet_negative(2, 0, 120, 10);

// indicator_array(8,2);
// translate([0,0, indicator_z]) spacer();

spacer();
