
include <wing_dimensions.scad>

module panel0()
{
   import("wing.stl", convexity = 10);
}

module wing_upper_skin(thickness){
   difference(){
      panel0();
      translate([0,0,-thickness]){
         panel0();
      }
   }
}

module wing_lower_skin(thickness){
   difference(){
      panel0();
      translate([0,0,thickness]){
         panel0();
      }
   }
}

module wing_unskinned(thickness){

   difference(){
      panel0();
      union(){
         wing_lower_skin(thickness);
         wing_upper_skin(thickness);
      }
   }
}

module wing_spar_blank()
{
//   spar_pos_pc = [0.25, 0.2];
//   spar_width = [ 6,3];
   spar_pos0 = spar_pos_pc[0] * panel_chord[0] + panel_offset[0];
   spar_pos1 = spar_pos_pc[1] * panel_chord[1] + panel_offset[1];
   //spar_width = 6; 
  
   spar_blank_poly = [
      [spar_pos0 - spar_width[0]/2,0],
      [spar_pos1 - spar_width[1] /2,panel_halfspan],
      [spar_pos1 + spar_width[1] /2,panel_halfspan],
      [spar_pos0 + spar_width[0]/2,0]
   ];

   translate([0,0,-7]){
      linear_extrude(height = 20){
         polygon( points = spar_blank_poly);
      }
   }

//   translate([spar_pos -spar_width/2,-1,-7]){
//      cube([spar_width,panel_halfspan+2,22]);
//   }
}

module wing_spar()
{
   intersection(){
      wing_unskinned(0.8);
      wing_spar_blank();
   }
}


module rib_blanks()
{
   for ( i = [0:len(rib_list)-1]){
      pos = rib_list[i][0];
      rib_thickness = rib_list[i][1];
      // ignore angle for now
      translate( [0,pos-rib_thickness/2,-7]){
         cube([panel_chord[0],rib_thickness,20]);
      }
   }
}

//module upper_rib_cap_blanks()
//{
//   
//   for ( i = [0:len(rib_list)-1]){
//      pos = rib_list[i][0];
//      //rib_thickness = rib_list[i][1];
//      
//      // ignore angle for now
//      translate( [0,pos-rib_cap_width/2,-10]){
//         cube([panel_chord[0],rib_cap_width,25]);
//      }
//   }
//}

module rib_cap_blanks()
{
   //rib_cap_width = 6;
   for ( i = [0:len(rib_list)-1]){
      pos = rib_list[i][0];
      translate( [0,pos-rib_cap_width/2,-10]){
         cube([panel_chord[0],rib_cap_width,25]);
      }
   }
}

//module upper_skin(){
//   difference(){
//      //panel0_lower_skin_0_8();
//      wing_upper_skin(0.8);
//      union(){
//         translate([65,-10,-10]){
//            cube([200,520,30]);
//         }
//      rotate([0,0,-0.7]){
//         translate([-1,-10,-10]){
//            cube([7,520,30]);
//         }
//   }
//      }
//   }
//   intersection(){
//      upper_rib_cap_blanks();
//      wing_upper_skin(0.8);
//   };
//}

module wing_ribs(){
   intersection(){
      union(){
         rib_blanks();
         wing_spar_blank();
      }
      
      wing_unskinned(0.8);
   }
}

//module lower_skin(){
//   difference(){
//      wing_lower_skin(0.8);
//      union(){
//         translate([55,-10,-10]){
//            cube([200,520,30]);
//         }
//         rotate([0,0,-0.7]){
//            translate([-1,-10,-10]){
//               cube([7,520,30]);
//            }
//         }
//      }
//   }
//   intersection(){
//      lower_rib_cap_blanks();
//      wing_lower_skin(0.8);
//   }
//}

module te_blank(){
   x = 25;
   y = 450;
   z = 2;
   bev = 5;
   pts = [
         [0,-0.2],
         [bev,-z/2],
         [x,-z/2],
         [x,z/2],
         [bev,z/2],
         [0,0.2],
         [0,-0.2]
   ];
   te_diff = (panel_chord[1] + panel_offset[1]) - (panel_chord[0] + panel_offset[0]);
   angle = atan2(te_diff,panel_straight_halfspan);
   translate([panel_chord[0]- x,0,1.5]){
      rotate([0,0,-(angle+0.7)]){
      rotate([0,3,0]){
        rotate([-90.,0,0]){
            translate([0,0,-10]){
               linear_extrude( height = y +20){
                 polygon(points = pts);
               }
            }
        }
        // cube([20,250,2]);
      }
      }
   }
}

module trailing_edge(){
   intersection(){
     te_blank();
     panel0();
   }
}

module le_blank()
{
   translate([-4,0,-4]){
      rotate([0,0,-0.8]){
         cube([10,1010,10]);
      }
   }
}

module leading_edge(){
   intersection(){
      translate([0,0,-3]){
         linear_extrude(height = 8){
            difference(){
               wing_plan();
               translate([4,-4]){
                  wing_plan();
               }
            }
         }
      }
      panel0();
   }
}

module wing_plan(){
   projection(cut = false){
      panel0();
   }
}

module lower_le_sheeting_blank()
{
   spar_pos0 = spar_pos_pc[0] * panel_chord[0] + panel_offset[0];
   spar_pos1 = spar_pos_pc[1] * panel_chord[1] + panel_offset[1];
   //spar_width = 6; 
  
   le_blank_poly = [
      [panel_offset[0] -1,0],
      [panel_offset[1] -1 ,panel_halfspan],
      [spar_pos1,panel_halfspan],
      [spar_pos0,0]
   ];
   translate([0,0,-7]){
      linear_extrude(height = 20){
        // intersection(){
        //    wing_plan();
            polygon (points = le_blank_poly);
        // }
      }
   }
}

module lower_le_sheeting(){
  intersection(){
     lower_le_sheeting_blank();
     wing_lower_skin(0.8);
   }
}

module upper_le_sheeting_blank()
{

   sheet_pos0 = spar_pos_pc[0] * panel_chord[0] + panel_offset[0];
   sheet_pos1 = spar_pos_pc[1] * panel_chord[1] + panel_offset[1];
   //spar_width = 6; 
  
   le_blank_poly = [
      [panel_offset[0] -1,0],
      [panel_offset[1] -1 ,panel_halfspan],
      [sheet_pos1 ,panel_halfspan],
      [sheet_pos0 ,0]
   ];
   translate([0,0,-7]){
      linear_extrude(height = 20){
        // intersection(){
         //   wing_plan();
            polygon (points = le_blank_poly);
        // }
      }
   }
}

module upper_le_sheeting(){
  intersection(){
     upper_le_sheeting_blank();
     wing_upper_skin(0.8);
   }
}

module le_sheeting()
{
   lower_le_sheeting();
   upper_le_sheeting();
}

module rib_caps_sheeting_blank()
{
   translate([0,0,-7]){
      linear_extrude(height = 20){
         difference(){
            wing_plan();
            translate ([-50,-10]){
               rotate([0,0,-1.5]){
                  square([100,panel_halfspan + 20]);
               }
            }
         }
      }
   }
}
module rib_caps()
{
   intersection(){

     // rib_caps_sheeting_blank();
      rib_cap_blanks();
      union(){
         wing_lower_skin(0.8);
         wing_upper_skin(0.8);
      }
   }
}

if (1){
   rib_caps();
   wing_ribs();
   leading_edge();
   trailing_edge();
   lower_le_sheeting();
   upper_le_sheeting();
  //  wing_spar();
}else{
   wing_spar();
   %panel0();
  // upper_skin();
}




























