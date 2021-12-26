include <../bezel_config_3_in.scad>;
use <../bezel_lib.scad>;

large_bezel();

module large_bezel(num_encs=0, as_die=false) {
    main_bezel(num_pots=num_encs, as_die=as_die);
}
