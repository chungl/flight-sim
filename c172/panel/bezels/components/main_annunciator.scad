use <../bezel_lib.scad>;

// WARNING: For some reason this mesh tends to be broken and requires repair.
// Check the sliced model carefully, even if the render appears correct.
// https://www.formware.co/onlinestlrepair

// Annunciator Bezel
annunc_view_h=15.2;
annunc_view_w=72.1;
annunc_r=3.6;
annunc_button_area_w=0;
annunc_wall_t=1;

module main_annunciator() {
    annunciator(
        view_w=annunc_view_w,
        view_h=annunc_view_h,
        wall_t=annunc_wall_t,
        outer_r=annunc_r
    ) {
        pot_cut(x=7, y=7, d=3.8);
        tactile_button_wires(x=7, y=7, wire_cut_w=2*annunc_view_h);
    }
};

main_annunciator();
