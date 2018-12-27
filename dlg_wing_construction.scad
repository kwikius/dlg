
include <wing_dimensions.scad>

show_whole_construction = 1;
show_plan_and_rib_blanks = 2;
show_wing_ribs = 3;
show_wing_unskinned = 4;
show_wing_lower_skin = 5;
show_wing_upper_skin = 6;
show_wing_upper_le_sheeting = 7;
show_wing_lower_le_sheeting = 8;
show_wing_spar = 9;
show_leading_edge_blank = 10;
show_ribs_output = 11;
show_jig_moulds_output = 12;
show_wing_jig = 13;
show_wing_jig_plan = 14;

show_mode = show_whole_construction;

module panel0()
{
   import("wing.stl", convexity = 10);
}

module wing_unskinned0_8(){
   import("wing_unskinned0_8.stl", convexity = 10);
}

module wing_lower_skin0_8(){
   import("wing_lower_skin0_8.stl", convexity = 10);
}

module wing_upper_skin0_8(){
   import("wing_upper_skin0_8.stl", convexity = 10);
}

module raw_wing_jig(){
   import("wing_jig.stl", convexity = 10);
}

module wing_jig_plan(){
   projection(cut = false){
      raw_wing_jig();
   }
}

module wing_jig_shape(){
   difference(){
      raw_wing_jig();
      translate([-0.01,0,0]){
         jig_leading_edge_blank();
      }
   }
}

module wing_jig_blanks()
{
   thickness = 3;
   list = concat(rib_list,jig_rib_list);
   for ( i = [0:len(list)-1]){
      pos = list[i][0];
      angle = list[i][2];
      offset = panel_offset[0] + (panel_offset[1] - panel_offset[0]) * pos / panel_halfspan;
      chord = (panel_chord[0] - (panel_chord[0] -panel_chord[1]) * pos / panel_halfspan) / cos(angle);
      translate( [offset,pos-thickness/2,-30]){
         rotate([0,0,angle]){
            cube([chord,thickness,35]);
         }
      }
   }
}

module wing_jig_mould_blank(i){
   thickness = 3;
   list = concat(rib_list,jig_rib_list);
   pos = list[i][0];
   angle = list[i][2];
   offset = panel_offset[0] + (panel_offset[1] - panel_offset[0]) * pos / panel_halfspan;
   chord = (panel_chord[0] - (panel_chord[0] -panel_chord[1]) * pos / panel_halfspan) / cos(angle);
   translate( [offset,pos-thickness/2,-30]){
      rotate([0,0,angle]){
         cube([chord,thickness,35]);
      }
   }
}

module wing_jig_mould(i){
   list = concat(rib_list,jig_rib_list);
   pos = list[i][0];
   rotate([-90,0,0]){
      translate([0,-pos,0]){
         intersection(){
            wing_jig_mould_blank(i);
            difference(){
               wing_jig_shape();
               translate([0,-1,-25]){
                  cube([200,500,20]);
               }
            }
         }
      }
   }
}



module wing_jig_moulds_output(){
  list1 = concat(rib_list,jig_rib_list);
   rib_spacing = 15;
   for ( i = [0:len(list1)-1]){
      translate([0,i *rib_spacing, 0]){
         projection(){
            wing_jig_mould(i);
         }
      }
   }
}

module jig_leading_edge_blank(){
   translate([0,0,-3]){
      linear_extrude(height = 8){
         difference(){
            wing_jig_plan();
            translate([4.01,-4.0]){
               wing_jig_plan();
            }
         }
      }
   }
}

module wing_jig(){
   intersection(){
      wing_jig_blanks();
      difference(){
         wing_jig_shape();
         translate([0,-1,-25]){
            cube([200,500,20]);
         }
      }
   }
}

module wing_jig_moulds_plan_output(){
   projection(){
      wing_jig();
      translate([0,0,-50]){
         trailing_edge();
         leading_edge();
      }
   }
}


module leading_edge_blank(){
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
   spar_pos0 = spar_pos_pc[0] * panel_chord[0] + panel_offset[0];
   spar_pos1 = spar_pos_pc[1] * panel_chord[1] + panel_offset[1];

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
}

module wing_spar()
{
   intersection(){
      wing_unskinned0_8();
      wing_spar_blank();
   }
}

module rib_blanks()
{
   list = concat(rib_list,wing_rib_list);
   difference(){
      
      for ( i = [0:len(list)-1]){
         pos = list[i][0];
         rib_thickness = list[i][1];
         angle = list[i][2];
         offset = panel_offset[0] + (panel_offset[1] - panel_offset[0]) * pos / panel_halfspan;
         chord = (panel_chord[0] - (panel_chord[0] -panel_chord[1]) * pos / panel_halfspan) / cos(angle);
         translate( [offset,pos-rib_thickness/2,-7]){
            rotate([0,0,angle]){
               cube([chord,rib_thickness,20]);
            }
         }
      }
      union(){
         wing_spar_blank();
         te_blank();
         leading_edge_blank();
      }
   }
}

module rib_blank(i){
   list = concat(rib_list,wing_rib_list);
   pos = list[i][0];
   rib_thickness = list[i][1];
   angle = list[i][2];
   offset = panel_offset[0] + (panel_offset[1] - panel_offset[0]) * pos / panel_halfspan;
   chord = (panel_chord[0] - (panel_chord[0] -panel_chord[1]) * pos / panel_halfspan) / cos(angle);
   difference(){
         translate( [offset,pos-rib_thickness/2,-7]){
            rotate([0,0,angle]){
               cube([chord,rib_thickness,20]);
            }
         }
     // }
      union(){
         wing_spar_blank();
         te_blank();
         leading_edge_blank();
      }
   }
}


module wing_rib_section(i)
{
   list = concat(rib_list,wing_rib_list);
   pos = list[i][0];
   rib_thickness = list[i][1];
   angle = list[i][2];
   offset = panel_offset[0] + (panel_offset[1] - panel_offset[0]) * pos / panel_halfspan;
   chord = (panel_chord[0] - (panel_chord[0] -panel_chord[1]) * pos / panel_halfspan) / cos(angle);

   rotate([-90,0,0]){
      translate( [-offset,-(pos),0]){
        wing_rib(i);
      }
   }
}

module ribs_output(){
   list1 = concat(rib_list,wing_rib_list);
   rib_spacing = 15;
   for ( i = [0:len(list1)-1]){
      translate([0,i *rib_spacing, 0]){
         projection(){
            wing_rib_section(i);
         }
      }
   }
}

module wing_rib(i)
{
   intersection(){
       rib_blank(i);
       wing_unskinned0_8();
   }
}

module wing_ribs(){
   intersection(){
       rib_blanks();
       wing_unskinned0_8();
   }
}

module rib_cap_blanks()
{
    list = concat(rib_list,wing_rib_list);
   for ( i = [0:len(list)-1]){
      pos = list[i][0];
      angle = list[i][2];
      offset = panel_offset[0] + (panel_offset[1] - panel_offset[0]) * pos / panel_halfspan;
      chord = (panel_chord[0] - (panel_chord[0] -panel_chord[1]) * pos / panel_halfspan)/cos(angle);
      translate( [offset,pos-rib_cap_width/2,-7]){
         rotate([0,0,angle]){
            cube([chord,rib_cap_width,20]);
         }
      }
   }
}

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

module leading_edge_blank(){
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
}

module leading_edge(){
   intersection(){
      leading_edge_blank();
      panel0();
   }
}

module wing_plan(){
   projection(cut = false){
      panel0();
   }
}

module lower_le_sheeting_blank_with_le()
{
   spar_pos0 = spar_pos_pc[0] * panel_chord[0] + panel_offset[0];
   spar_pos1 = spar_pos_pc[1] * panel_chord[1] + panel_offset[1];

   le_blank_poly = [
      [panel_offset[0] -1,0],
      [panel_offset[1] -1 ,panel_halfspan],
      [spar_pos1,panel_halfspan],
      [spar_pos0,0]
   ];
 
   translate([0,0,-7]){
      linear_extrude(height = 20){
         polygon (points = le_blank_poly);
      }
   }
}

module lower_le_sheeting_blank()
{
  difference(){
     lower_le_sheeting_blank_with_le();
     leading_edge_blank();
  }
}

module lower_le_sheeting(){
   intersection(){
      lower_le_sheeting_blank();
      //wing_lower_skin(0.8);
      wing_lower_skin0_8();
   }
}

module upper_le_sheeting_blank()
{
   sheet_pos0 = spar_pos_pc[0] * panel_chord[0] + panel_offset[0];
   sheet_pos1 = spar_pos_pc[1] * panel_chord[1] + panel_offset[1];

   le_blank_poly = [
      [panel_offset[0] -1,0],
      [panel_offset[1] -1 ,panel_halfspan],
      [sheet_pos1 ,panel_halfspan],
      [sheet_pos0 ,0]
   ];
   translate([0,0,-7]){
      linear_extrude(height = 20){
            polygon (points = le_blank_poly);
      }
   }
}

module upper_le_sheeting(){
  intersection(){
     upper_le_sheeting_blank();
    // wing_upper_skin(0.8);
      wing_upper_skin0_8();
   }
}

module le_sheeting()
{
   lower_le_sheeting();
   upper_le_sheeting();
}

module lower_rib_caps()
{
   intersection(){
      // rib_caps_sheeting_blank();
      rib_cap_blanks();
      //wing_lower_skin(0.8);
      difference(){
         wing_lower_skin0_8();
         union(){
            lower_le_sheeting_blank_with_le();
            te_blank();
         }
      }
   }
}

module upper_rib_caps()
{
   intersection(){
      // rib_caps_sheeting_blank();
      rib_cap_blanks();
      //wing_lower_skin(0.8);
      difference(){
         wing_upper_skin0_8();
         union(){
            lower_le_sheeting_blank_with_le();
            te_blank();
         }
      }
   }
}

module rib_caps()
{
  upper_rib_caps();
  lower_rib_caps();
}

if ( show_mode == show_plan_and_rib_blanks){
   rib_blanks();
   //%rib_cap_blanks();
   wing_plan();
   wing_spar();
   leading_edge();
   te_blank();
}else{
  if ( show_mode == show_whole_construction){
      lower_rib_caps();
      upper_rib_caps();
      wing_ribs();
      leading_edge();
      trailing_edge();
      le_sheeting();
       wing_spar();
  }else {
      if ( show_mode == show_wing_ribs){
         wing_ribs();
       // leading_edge();
       //  wing_jig();
      }else{
         if ( show_mode == show_wing_unskinned){
          //  wing_unskinned0_8();
            wing_unskinned0_8();
         }else{
            if (show_mode == show_wing_lower_skin){
              // wing_lower_skin(0.8);
               wing_lower_skin0_8();
            }else{
               if (show_mode == show_wing_upper_skin){
                 // wing_upper_skin(0.8);
                  wing_upper_skin0_8();
               }else{
                  if( show_mode == show_wing_upper_le_sheeting){
                      upper_le_sheeting();
                  }else{
                     if( show_mode == show_wing_lower_le_sheeting){
                        lower_le_sheeting();
                     }else{
                        if ( show_mode == show_wing_spar){
                           wing_spar();
                        }else{
                           if(show_mode == show_leading_edge_blank){
                              leading_edge_blank();
                           }else{
                              if(show_mode == show_ribs_output){
                                 ribs_output();
                              }else{
                                 if(show_mode == show_jig_moulds_output){
                                    wing_jig_moulds_output();
                                 }else{
                                    if (show_mode == show_wing_jig){
                                       wing_jig();
                                    }else{
                                       if(show_mode == show_wing_jig_plan){
                                          //wing_jig_plan();
                                          wing_jig_moulds_plan_output();
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }
}


























