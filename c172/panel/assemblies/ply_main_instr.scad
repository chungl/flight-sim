include <../../frame_lib.scad>;
include <../bezels/bezel_config.scad>;
use <main_instr_bezels.scad>;

ply_main_instr();

panel_w=17*25.4;
panel_h=11*25.4;

reference_gauge_x=54.8;
reference_gauge_y=47.8;

module ply_main_instr() {
    difference() {
        sheet_material(
            size=[panel_w, panel_h, veneer_material_t],
            material_color=color_veneer
        );
        translate([reference_gauge_x,reference_gauge_y,-_tab_base_h]) main_instr_bezels(true);
    }
}

module main_instr_panel() {
    ply_main_instr();
    color("black") translate([reference_gauge_x, reference_gauge_y, -_tab_base_h]) main_instr_bezels();
}

