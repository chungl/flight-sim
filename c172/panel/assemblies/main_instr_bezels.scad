include <../bezels/bezel_config_3_in.scad>;
include <../bezels/components/large_bezel.scad>;
include <../bezels/components/attitude_indicator.scad>;

col_spacing=90.4;
row_spacing=94.1;


module bezel_row(spacing=col_spacing) {
    for (i = [ 0 : $children - 1 ]) {
        translate([i*spacing, 0, 0]) children(i);
    }
}

module bezel_grid(spacing=row_spacing) {
    for (j = [ 0 : $children - 1] ) {
        translate([0, j*spacing, 0]) children(j);
    }
}

module main_instr_bezels(as_die=false) {
    translate([0,0,(as_die ? -NOTHING : 0)]) 
    scale([1,1,(as_die ? (total_h + 2*NOTHING)/total_h : 1)]) 
    bezel_grid(row_spacing) {
        // BOTTOM ROW
        bezel_row() {
            // LEFT COL
            large_bezel(as_die=as_die);
            large_bezel(num_encs=2, as_die=as_die);
            large_bezel(as_die=as_die);
            large_bezel(num_encs=1, as_die=as_die);
        };
        // TOP ROW
        bezel_row() {
            large_bezel(num_encs=1, as_die=as_die);
            attitude_indicator(as_die=as_die);
            large_bezel(num_encs=1, as_die=as_die);
            large_bezel(num_encs=1, as_die=as_die);
        };
    }
}

main_instr_bezels();
