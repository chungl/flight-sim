color_frame="wheat";
color_veneer="burlywood";
color_desk="darkgray";


veneer_material_t=5;
frame_material_t=12;

proj_desk_gap_d=7;


PLANE_XY="PLANE_XY";
PLANE_XZ="PLANE_XZ";
PLANE_YZ="PLANE_YZ";

QUADRANT_I="TOP_RIGHT";
QUADRANT_II="TOP_LEFT";
QUADRANT_III="BOT_LEFT";
QUADRANT_IV="BOT_RIGHT";

REFERENCE_FACE_FRONT="FRONT";
REFERENCE_FACE_BACK="BACK";
FRONT=REFERENCE_FACE_FRONT;
BACK=REFERENCE_FACE_BACK;

function map_vector_to_plane(vector, plane) =
    let (
        _x=vector[0],
        _y=vector[1],
        _z=vector[2]
    ) 
        plane == PLANE_XY ? [_x, _y, _z] : (
            plane == PLANE_XZ ? [_x, _y, _z] : [_z, _x, _y]
        );

function translate_sheet(vector, quadrant, reference_face=REFERENCE_FACE_FRONT) =
    let (
        _x=vector[0],
        _y=vector[1],
        _z=vector[2]
    )
        [
            (quadrant == QUADRANT_II || quadrant == QUADRANT_III) ? -_x : 0,
            (quadrant == QUADRANT_III || quadrant == QUADRANT_IV) ? -_y : 0,
            reference_face == REFERENCE_FACE_BACK ? -_z : 0
        ];

module sheet_material(
    size,
    plane=PLANE_XY,
    quadrant=QUADRANT_I,
    reference_face=FRONT,
    material_color=color_frame
) {
    color(material_color)
    translate(map_vector_to_plane(
        translate_sheet(size, quadrant, reference_face),
        plane
    ))
    cube(map_vector_to_plane(size,plane));
}
