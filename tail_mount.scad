// dlg tailplane mount

//use </home/andy/cpp/projects/openscad_utils/foils/naca64009.scad>

tail_boom_dia = 4 ;
tail_boom_mount_clearance = 0.25;
mount_x_len = 15;
//mount_y_len = 10;
mount_height = 6.5;
mount_wall_thickness = 1;
tail_boom_dia1= tail_boom_dia + tail_boom_mount_clearance;
mount_incidence_angle = 2.5;
module tail_mount(){

// pylon
   difference(){
      rotate([0,mount_incidence_angle,0]){
         translate([mount_x_len/2,0,tail_boom_dia1/2]){
            linear_extrude(height = mount_height, scale = [0.8,0.5] ){
               scale([mount_x_len/3, 1.25]){
                   circle([1,1], $fn = 50);
               }
            }
         }
      // mountplate
         translate([mount_x_len/2,0,mount_height + tail_boom_dia1/2]){
            rotate([180,0,0]){
               scale([1,1.5,1]){
                  rotate_extrude($fn = 50){
                     intersection(){
                        scale([mount_x_len/2 ,0.5]){
                            circle([1,1], $fn = 50);
                        }
                        square([mount_x_len,10]);
                     }
                  }
               }
            }
         }
      }
      union(){
      translate([-1,0,0]){
         rotate([0,90,0]){
            cylinder (d = tail_boom_dia1, h= mount_x_len+2, $fn = 50);
         }
      }
      translate([-1,0,tail_boom_dia1/2+1.0]){
         rotate([0,90,0]){
            cylinder (d = 1, h= mount_x_len+2, $fn = 50);
         }
      }
      }
   }


      
// tailboom ring
   rotate([0,90,0]){
      rotate_extrude($fn = 50){
         translate([tail_boom_dia1/2,0]){
            difference(){
               translate([0,mount_x_len/2,0]){
                  scale([ 0.5,mount_x_len/2]){
                     circle([1,1], $fn = 50);
                  }
               }
               translate([-10,0]){
                  square([10,mount_x_len + 2]);
               }
            }
         }
      }
   }

}

tail_mount();









