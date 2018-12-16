/*

Tranquility FPV thermal soarer.

Copyright (C) 2017 Andy Little

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU General Public License for more details.
   }
 You should have received a copy of the GNU General Public License
 along with this program. If not, see http://www.gnu.org/licenses./
*/


fuselage_width_ratio = 0.4;
fuselage_height_ratio = 0.65;


wing_incidence = 2.5;
tail_incidence = 1;

tail_length = 350;

// true to show wing construction
// false to just show wing shape
show_construction = true;

module fuselage_pod()
{
   intersection(){
     translate([0,0,-25]){
     linear_extrude( height= 50){
      scale([7,fuselage_width_ratio]){
         circle(d = 50, $fn = 50);
      }
     }
     }

     translate([0,25,0]){
     rotate([90,0,0]){
     linear_extrude( height= 50){
      scale([7,fuselage_height_ratio]){
         circle(d = 50, $fn = 50);
      }
     }
     }
     }
 }
    
//      scale([7,fuselage_width_ratio,fuselage_height_ratio]){
//         sphere(d = 50, $fn = 50);
//      }
      translate([-30,0,0]){
         scale ( [1,fuselage_width_ratio,fuselage_height_ratio]){
            rotate([0,-90,0]){
               cylinder( r1=4,r2= 4, h = tail_length+85, $fn = 50);
            }
         }
      }
}

module wing(){
   polyhedral_angle0 = 11;

   translate([0,0,8]){

      rotate([-polyhedral_angle0,0,0]){
         rotate([0,0,180]){
           if ( show_construction){
              import("dlg_wing_construction.stl", convexity = 10);
            }else{
               import("wing.stl", convexity = 10);
            }
         }

      }
   }
}

module tailplane_half(){

   size = 1;
      scale([size +0.1,size,size]){
      import("tailplane.stl", convexity = 10);
      }
}

module battery()
{
  translate([-40,-6,-15]){
   cube([60,12,30]);
  }
}

module fin()
{
   translate([60,0,0]){
         rotate([90,0,0]){
            scale([1,0.6,1]){
               import("tailplane.stl", convexity = 10);
            }
         }

         rotate([-90,0,0]){
            scale([1,0.6,1]){
               import("tailplane.stl", convexity = 10);
            }
         }
   }
}

module tailplane()
{
   tailplane_half();
   mirror([0,1,0]){
     tailplane_half();
   }
  
}

module tail()
{
   translate([-(tail_length+55),0,-25]){
      rotate([0,-tail_incidence,0]){
         rotate([0,0,180]){
            tailplane();
         }
      }
   }
 translate([-(tail_length+59),0,-6.5]){
         rotate([0,0,180]){
              fin();
         }
   }
}

module joiner()
{
   joiner_length = 90;

   translate([-49,-joiner_length/2,6]){
      cube([1,joiner_length,5]);
   }
/*
     translate([-50,0,6]){
        rotate([-90,0,0]){
           cylinder ( r= 3, h= joiner_length, $fn=20);
        }
     }
*/

}

wing_color = [0.7,0.6,1];
fuse_color = [1,0.6,1];

module whole_plane() {
   translate([80,0,0]){
      color(fuse_color){
         translate([-30,0,-10]){
            fuselage_pod();
         }
      }
    //  joiner();
      translate([0,0,2]){
         color(wing_color){
            translate([-10,0,-8]){
               rotate([0,-wing_incidence,0]){
                  wing();
                  mirror([0,1,0]){wing();}
               }
            }
         }
      }
      color(wing_color){
         tail();
      }
   }
}

whole_plane();











