base_d=60;
base_t=1;
servo_spacing=39;
faceplate_mount_spacing=38;
faceplate_mount_d=1.5;
servo_shaft_d=2;
mount_d=2.5;
mount_body_d=8;

standoff_h=24;
standoff_x=20;
standoff_y=10;

module base() {
    union() {
        cylinder(d=base_d, h=base_t);
    }
}