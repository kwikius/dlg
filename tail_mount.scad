
tailmount_printing = false;
tailmount_tailboom_dia = 4 ;
tailmount_tailboom_clearance = 0.2;
tailmount_tube_wall_thickness = 0.5;
tailmount_pylon_thickness = 1.5;
tailmont_plate_thickness = 0.5;
tailmount_plate_y_len = 25;
tailmount_x_len = 12;
tailmount_standoff_height = 12.5;
tailmount_incidence_angle = 2.5;
tailmount_plate_fillet_width = 2;

// x_length
// standoff_height
// tailboom_dia

module tailboom_tube(){
   dia1 = tailmount_tailboom_dia + 2 * tailmount_tailboom_clearance;
   dia2 = dia1 + 2 * tailmount_tube_wall_thickness;
   offset = (dia1 + tailmount_pylon_thickness)/2 +1 ;
   rotate([0,90,0]){
      difference(){
         hull(){
//            translate([-offset,0,0]){
//              cylinder(d= tailmount_pylon_thickness, h = tailmount_x_len/1.5 ,$fn = 20);
//            }
          translate([-offset,,0,tailmount_pylon_thickness/2]){
               sphere(d = tailmount_pylon_thickness, $fn = 50);
            }
            translate([-offset,,0,tailmount_x_len/1.5 - tailmount_pylon_thickness/2]){
               sphere(d = tailmount_pylon_thickness, $fn = 50);
            }
            cylinder(d= dia2, h = tailmount_x_len,$fn = 50);
           

         }
         translate([0,0,-2]){
            cylinder(d= dia1, h = tailmount_x_len + 4,$fn = 50);
         }
      }
   }
}

module tailmount_plate(){
   offset = tailmount_tailboom_dia /2 +  tailmount_tailboom_clearance + tailmount_standoff_height - tailmont_plate_thickness;
   translate([-1,-tailmount_plate_y_len/2,offset]){
      rotate([0,tailmount_incidence_angle,0]){
         cube ( [tailmount_x_len+2,tailmount_plate_y_len,tailmont_plate_thickness]);
       
      }
   }
}

module tailboom_pylon(){
   h1 = tailmount_x_len * tan(tailmount_incidence_angle);
   hp1 = tailmount_standoff_height - ( tailmount_tube_wall_thickness+ tailmont_plate_thickness/2);
//   pts = [
//   [0,0],
//   [0,hp1 + h1 -0.1],
//   [tailmount_x_len,hp1 -0.1],
//   [tailmount_x_len,0]
//   ];
   offset = tailmount_tailboom_dia/2 
      + tailmount_tailboom_clearance 
      + tailmount_tube_wall_thickness/2;

hull(){
translate([tailmount_pylon_thickness/2,0,offset]){
   cylinder ( d= tailmount_pylon_thickness, h = hp1 + h1 -0.3, $fn = 20);
}

translate([tailmount_x_len/ 1.5,0,offset]){
   cylinder ( d= tailmount_pylon_thickness, h = hp1 -0.3, $fn = 20);
}
}

//   translate([0,0,offset]){
//      rotate([90,0,0]){
//         translate([0,0,-tailmount_pylon_thickness/2]){
//            linear_extrude(height = tailmount_pylon_thickness){
//               polygon(points = pts);
//            }
//         }
//      }
//   }
}

module tailmount_plate_fillet()
{
   fw = tailmount_plate_fillet_width;
//   pts = [
//      [-fw,0],
//      [0,-fw * 1.5],
//      [0,fw * 1.5]
//   ];
   z_offset =  tailmount_tailboom_dia /2 +  tailmount_tailboom_clearance + tailmount_standoff_height - tailmont_plate_thickness;
   translate([0,0,z_offset]){
      rotate([0,tailmount_incidence_angle,0]){
//         translate([tailmount_x_len/1.5,0,0]){
//            rotate([0,-90,0]){
//               linear_extrude(height = tailmount_x_len/1.5){
//                  polygon(points = pts);
//               }
//            }
//         }
hull(){
  translate([fw*1.5,0,-fw ]){
      cylinder( d1 = 0, d2 = fw *3, h = fw, $fn = 50);
  }
   translate([tailmount_x_len/ 1.5,0,-fw ]){
      cylinder( d1 = 0, d2 = fw *3, h = fw, $fn = 50);
  }
      }
   }
}
}

module tail_mount(){
  zoffset = tailmount_tailboom_dia/2 +
     tailmount_tailboom_clearance +
     tailmount_tube_wall_thickness ;
cube_height = tailmount_standoff_height +  tailmount_tailboom_dia +
    2* tailmount_tailboom_clearance +
    2* tailmount_tube_wall_thickness;
   intersection(){
      union(){
         tailboom_tube();
         tailmount_plate();
         tailboom_pylon();
         tailmount_plate_fillet();
      }
     
      difference(){
        translate([0,0,-zoffset]){
           scale ([2*tailmount_x_len/tailmount_plate_y_len,1,1]){
             cylinder (d= tailmount_plate_y_len , h = 30,$fn = 200);
           }
        }
        translate([-10,-((tailmount_plate_y_len+1)/2),-(zoffset+1)]){
           cube([10,tailmount_plate_y_len+1,cube_height + 2]);
        }
     }
   }    
}
if ( tailmount_printing)
{
   rotate([0,-90,0]){
      tail_mount();
   }
}else{
 tail_mount();
  // tailboom_pylon();


}

//tailmount_plate();