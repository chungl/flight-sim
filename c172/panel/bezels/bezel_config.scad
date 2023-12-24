// =====================================================
// =             MISC. MODEL SETTINGS                  =
// =====================================================

// This generates solid roofs where there are holes that
// may otherwise be difficult to print without external support.
MODEL_SUPPORT_FOR_HANGING_CIRCLES=true;

// The thickness of support material to print that will
// fill in holes in ceilings. I recommend one print layer.
SUPPORT_LAYER_H=0.25;

// Number of faces in a "circle".
// 360 gives a pretty smooth circle on most printers.
// 100 has some visible edges but renders faster. Good for development.
$fn=360;

// Certain cuts and other model features are oversized
// by this marginal amount to eliminate rendering artifacts.
// This should not actually change the shape of the part
// if designed properly, and the change would be negligble anyway.
// Consider changing this to 0 for print renders.
// Use 0.1 or smaller for viewing quick renders.
NOTHING=0.1;

// =====================================================
// =               SIZE DEFINITIONS                    =
// =====================================================
// This section allows you to store some key measurements
// These numbers do not get applied to the models directly.
// Instead, use them in the GLOBAL CONFIGURATIONS sections
// below or as arguments to individual part modules in the
// PART CONSTRUCTION section.

_CHAMFER_WIDTH=3.25;
_FLAT_WIDTH=0.75;
LARGE_BEZEL_OUTER_DIAMETER=40.25*2;

SMALL_BEZEL_OUTER_DIAMETER=28.5*2;

YOKE_BEZEL_INNER_DIAMETER=49.2;
YOKE_FLAT_FROM_CENTER=46-YOKE_BEZEL_INNER_DIAMETER/2;

ENCODER_HEIGHT=7;
ENCODER_MAJOR_WIDTH=13;
ENCODER_MINOR_WIDTH=12.5;
ENCODER_SHAFT_DIAMETER=7.3;

BUTTON_HEIGHT=10.8+0.75;
BUTTON_MAJOR_WIDTH=7.5;
BUTTON_MINOR_WIDTH=7.5;
BUTTON_SHAFT_DIAMETER=6.5;
_BUTTON_HEIGHT_ABOVE_PANEL=BUTTON_HEIGHT-ENCODER_HEIGHT;


// =====================================================
// =           BASIC GLOBAL CONFIGURATIONS             =
// =====================================================

NUM_OUTER_POTS=0;

od=LARGE_BEZEL_OUTER_DIAMETER;

pot_h=ENCODER_HEIGHT;
pot_shaft_hole_d=ENCODER_SHAFT_DIAMETER;
pot_major=ENCODER_MAJOR_WIDTH;
pot_minor=ENCODER_MINOR_WIDTH;


// Total bezel height is divided into three regions: Tab (sits behind the panel), Embeded (in the panel), and Raised (above the panel).
panel_thickness=5.3; // Thickness of the panel material (the Embeded portion of the bezel)
bezel_height_above_panel=pot_h-7; // For flush bezel, set this to 0.

// Do not modify
_or=od/2;

screw_position_offset=4.75;
screw_position_r=_or+screw_position_offset;
screw_tab_w=10;
screw_socket_od=3.15*2;
screw_socket_id=1.5*2;
screw_socket_h=3;
tab_socket_backstop_h=0.75; // Thickness of the "bottom" of the screw socket, or 0 to disable.
tab_socket_backstop_hole_id=1; //.8*2; // Diameter of a smaller hole in the bottom of the socket, or 0 for none.
backstop_t=1.5;

pot_position_offset=screw_position_offset+1;
pot_position_r=_or+pot_position_offset;
pot_tab_major=25;
pot_tab_fillet_r=4.675;
_pot_tab_circle_overlap=_or - sqrt(pow(_or,2)-pow((pot_tab_major/2),2)); // Arc height as fn of chord length and radius
pot_tab_minor= 2*(pot_position_r - _or + _pot_tab_circle_overlap);
pot_wire_cut_w=8.5;
pot_wire_cut_h=2.5;
total_h=pot_h + 1;

// Calculations for modeling. Do not modify
bezel_od=od-2*_FLAT_WIDTH;
id=bezel_od-2*_CHAMFER_WIDTH;
_bezel_offset=(bezel_od-id)/2;
_top_t=(od-bezel_od)/2;
_tab_base_h=total_h-panel_thickness-bezel_height_above_panel;
_tab_extension_l=screw_position_r-id/2;
