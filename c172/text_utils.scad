use <URW_Gordon_W01_Medium.ttf>
font = "URWGordonW01\\-Medium:style=Regular";
text_size=3.5;
text_line_height=1.3*text_size;


module multiline_text(strings, font=font, size=text_size, line_height=text_line_height, halign="center") {
  translate([0, line_height*(len(strings)-1)/2, 0])
    for (i = [0: len(strings) - 1]) {
        translate([0, -line_height * i, 0]) text(strings[i], font=font, size=size, valign="center", halign=halign);
    };
}


// halign=["left"]|"center"|"right"
// for valign, specify index of character to center on (can be fraction)
module vertical_text_array(strings, halign="left", draw_line=false, char_align_index=0) {
    let (
        line_height=text_line_height,
        h = line_height*len(strings), 
        x_offset = halign == "left" ? 0.75*text_size : halign=="center" ? 0: -0.75*text_size
    ) {
        translate([0,-line_height*(len(strings)-1)/2 + char_align_index*line_height]) {
            translate([x_offset, 0]) multiline_text(strings, halign="center",line_height=line_height);
            if (draw_line) {
                line([0,h/2], [0, -h/2]);
            }
        }
    }   
}

// halign="left"|["center"]|"right"
// valign="top"|["center"]|"bottom"|"baseline"
module horizontal_text_array(string, font=font, size=text_size, valign="center", halign="center", h_offset=0, draw_line=false) {
    translate([h_offset,text_line_height/2]) text(string, font=font, size=size, valign=valign, halign=halign);
}
