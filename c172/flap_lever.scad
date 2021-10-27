$fn=100;

encoderR=3.10;
setScrewD=2;
armEncoderOuterR=11;

gymbalW=6;
outerGymbalT=3;
gymbalGap=.5;

//printGymbalAxisPins=true;
//gymbalAxisD=3;
//gymbalAxisGap=.35;

printGymbalAxisPins=false;
gymbalAxisD=1.7;
gymbalAxisGap=.4;

gymbalBottomLayerInnerInset=0.1;
gymbalBottomLayerT=.5;


armL=71;
armBaseT=2.4;

handleSlotW=3;
handleSlotH=3.8;
handleSlotD=15;
handleVisibleOffset=5;
handleHiddenOffset=2;
handleWidthTransitionD=1;
handleA=26;

potKey0Offset=35;

springL=30;
springW=5;
module createHandleInsert() {
 translate([handleVisibleOffset, 0, 0]) union() {
        hull() {
            translate([-handleVisibleOffset, 0, 0]) cylinder(d=handleSlotH, h=armBaseT);
            translate([handleHiddenOffset, 0, 0]) cylinder(d=handleSlotH, h=armBaseT);
        }
        hull() {
            translate([handleHiddenOffset, 0, 0]) cylinder(d=handleSlotH, h=armBaseT);
            translate([handleHiddenOffset + handleWidthTransitionD, 0, 0]) cylinder(d=handleSlotH, h=handleSlotW);
        }
        hull() {
            translate([handleHiddenOffset + handleWidthTransitionD, 0, 0]) cylinder(d=handleSlotH, h=handleSlotW);
            translate([handleSlotD - handleSlotH, 0, 0]) cylinder(d=handleSlotH, h=handleSlotW);
        }
 }
}

module createReinforceCone(x, yDir=1) {
  armReinforceBaseD=3.5;
  armReinforceTopD=1;
  armReinforceH=2;
  armHalfAngle=atan((armEncoderOuterR - handleSlotH/2)/armL);
  armReinforceEnd=x;
  halfArmHeightReinforceEnd=tan(armHalfAngle)*(armL - armReinforceEnd);
  translate([armReinforceEnd, yDir*halfArmHeightReinforceEnd, armBaseT]) cylinder(d1=armReinforceBaseD, d2=armReinforceTopD, h=armReinforceH);
}

module createArm() {
    union() {
        difference() {
            hull() {
               cylinder(r=armEncoderOuterR, h=armBaseT);
               translate([armL, 0, 0]) cylinder(d=handleSlotH, h=armBaseT);
            }
            cylinder(r=encoderR, h=10);
        }
        hull() {
            createReinforceCone(52);
            createReinforceCone(52, -1);
            createReinforceCone(springL + springW/2);
            createReinforceCone(springL + springW/2, -1);
        }
        hull() {
            createReinforceCone(0);
            createReinforceCone(springL + springW/2);
        }
        hull() {
            createReinforceCone(0, -1);
            createReinforceCone(springL + springW/2, -1);
        }
    }
}

module createOuterGymbal() {
 difference() {
     union() {
        createArm();
        cylinder(r=armEncoderOuterR, h=gymbalW);
     }
     union() {
         difference() {
             union() {
                 color("blue") translate([0, 0, gymbalW/2]) sphere(r=armEncoderOuterR-outerGymbalT);
                 color("purple") cylinder(r=sqrt(pow(armEncoderOuterR-outerGymbalT, 2) - pow(gymbalW/2 - gymbalBottomLayerT, 2)), h=gymbalBottomLayerT);
                 if(printGymbalAxisPins) {
                    color("orange") translate([0, armEncoderOuterR, gymbalW/2]) rotate([90, 0, 0]) cylinder(d=gymbalAxisD, h=2*armEncoderOuterR);
                 } else {
                    color("orange") translate([0, armEncoderOuterR, gymbalW/2]) rotate([90, 0, 0]) cylinder(d=gymbalAxisD + 2*gymbalAxisGap, h=2*armEncoderOuterR);
                 }
             }
         }
     }
  }
}

module springCut() {
  union() {
      translate([0, -springW/2 - gymbalGap, 0]) cube([springL, springW + 2*gymbalGap, armBaseT + gymbalAxisGap]);
      translate([springL, -springW/2 - gymbalGap/2, 0]) cylinder(d=gymbalGap, h=armBaseT);
      translate([springL, springW/2 + gymbalGap/2, 0]) cylinder(d=gymbalGap, h=armBaseT);
  }
}

module knurledPotKey() {
  rotate([0, 0, potKey0Offset]) union() {
    translate([encoderR - 1, -.4, 0]) cube([1, .8, gymbalW]);
    translate([-encoderR, -.4, 0]) cube([1, .8, gymbalW]);
  }
}

module spring() {
  color("coral") hull() {
    translate([springW/2 + encoderR + 1, 0, 0]) cylinder(d=springW, h=armBaseT);
    translate([springL, 0, 0]) cylinder(d=springW, h=armBaseT);
  }
}

module createInnerGymbal() {
    difference() {
        intersection() {
            cylinder(r=armEncoderOuterR, h=gymbalW);
             union() {
                 color("green") translate([0, 0, gymbalW/2]) sphere(r=armEncoderOuterR-outerGymbalT-gymbalGap);
                 if(printGymbalAxisPins) {
                    color("yellow") translate([0, armEncoderOuterR, gymbalW/2]) rotate([90, 0, 0]) cylinder(d=gymbalAxisD-gymbalAxisGap*2, h=2*armEncoderOuterR);
                 }
            }
        }
        if (!printGymbalAxisPins) {
            color("yellow") translate([0, armEncoderOuterR, gymbalW/2]) rotate([90, 0, 0]) cylinder(d=gymbalAxisD, h=2*armEncoderOuterR);
        }
        color("purple") difference() {
            cylinder(r=sqrt(pow(armEncoderOuterR-outerGymbalT, 2) - pow(gymbalW/2 - gymbalBottomLayerT, 2)), h=gymbalBottomLayerT);
    //                cylinder(r=sqrt(pow(armEncoderOuterR-outerGymbalT, 2) - pow(gymbalW/2,2)));
            translate([0,0,gymbalW/2]) sphere(r=armEncoderOuterR-outerGymbalT-gymbalGap-gymbalBottomLayerInnerInset);
        }
        translate([0, 0, -.01]) cylinder(r=encoderR, h=gymbalW + .02);
    }
}

module setScrewCut(a) {
    translate([0, 0, gymbalW/2]) rotate([ 0, 0, a]) rotate([0, -90, 0]) translate([0, 0, encoderR - .1]) cylinder(d=setScrewD, h=armEncoderOuterR - encoderR + .1);
}

difference() {
union() {
createOuterGymbal();
translate([armL, 0, 0]) rotate([0, 0, handleA]) createHandleInsert();
createInnerGymbal();
knurledPotKey();
}
setScrewCut(potKey0Offset);
setScrewCut(-45);
//springCut();
}
//spring();
