//$fn = 100;

// use front(); to render the front side
// use back(); to render the back side

// front();
// translate([0, 15, 0]) back();

//bothParts();

screwWithNut(nr=4, nd=2, s=10, sd=3, sr=2.6, wp=20);

// screwWithNut - draws a screw with nut. the object is placed
//                in z-direction centered at the origin
// 
// nr: radius of the nut
// nd: nut depth
// s:  space between nut and screen head
// sd: srew depth
// sr: screwRadius
// wp: with projection
// 
module screwWithNut(nr=5, nd=6.5, s=4, sd=6.5, sr=2.6, wp=0) {
	union() {
		translate([0, 0, sd/2]) hexagon(length = nr, depth = sd);
		translate([0, 0, sd]) cylinder(h=s, r=sr);
		translate([0, 0, s + nd/2 + sd]) hexagon(length = nr, depth = nd);
		if (wp > 0) {
			translate([-nr, 0, 0]) cube([2*nr, wp, sd]);
			translate([-nr, 0, s + sd]) cube([2*nr, wp, nd]);
		}
	}
}




module front() {
	difference() {
		bothParts();
		translate([-50, 2.5, 0]) cube([100, 40, 100]);
	}
}

module back() {
	difference() {
		difference() {
			bothParts();
			translate([-50, -37.5, 0]) cube([100, 40, 100]);
		}
		translate([0, 27, -5]) cylinder(h=50, r=4.5);
	}
}

module bothParts() {
	difference() {
		difference() {
			bottlefixer();
			nut(32, 20);
		}
		nut(-32, 20);
	}
}

// one of the two side nuts
module nut(dx = 0, dy = 0, dz = 0, h = 4.5) {
	union() {
		rotate(a=[90, 0, 0]) union() {
			translate([dx, dy, 7.5]) hexagon(length = 5, 10);
			translate([dx, dy, -10]) cylinder(h=15, r=2.6);
		}
		translate([dx-h	, -12.5 , 22]) cube([9, 10, 20]);
	}
}

// the whole thing without nuts
module bottlefixer() {
	difference() {
		difference() {
			difference() {
				difference() {
					difference() {
						difference() {
							difference() {
								union() {
									cylinder(h=40, r=30);
									translate([-40, -7.5, 0]) cube([80, 15, 40]);
								}
								// inner cylinder	
								cylinder(h=40, r=12.5);
							}
							union() {
								translate([32, 17.5, 20]) rotate(a=[90, 0, 0]) cylinder(h=10, r=6);
								translate([26, 7.5, 20]) cube([12, 12, 25]);
							}
						}
						union() {
							translate([-32, 17.5, 20]) rotate(a=[90, 0, 0]) cylinder(h=10, r=6);
							translate([-38, 7.5, 20]) cube([12, 12, 25]);
						}
					}
					// the big coke bottle
					rotate(a=[5, 0, 0]) translate([0, -68, -5]) cylinder(h=50, r=47);
				}
				translate([0, -13, 0]) {
					union() {
						rotate(a=[90, 0, 0]) translate([0, 10, 0]) hexagon(4.5, 6);
						translate([-4.5, -3, 10]) cube([9,6,40]);
					}
				}
			}
			rotate(a=[90, 0, 0]) translate([0, 10, 10]) cylinder(h=15, r=2.6);
		}
		rotate(a=[90, 0, 0]) translate([0, 30, 10]) cylinder(h=15, r=2.6);
	}
}











// -------------------------------
// 3rd party stuff
// -------------------------------




/*----------------------------------------------------------------------------*
* Defines common constants used throughout the AutoSCAD libraries.
*-----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*/

//--- Constants

/** The value of Pi
 */
PI = 3.1415926535897932;

/** Printer resolution (in mm)
 */
RESOLUTION = 0.3;

/** Base size for objects (in mm)
 *
 * The library is designed to generate things in 'units' - this defines the
 * size of a unit (in mm).
 */
BASE_SIZE = 2;

//--- Modules

/** Create an isosceles triangle
 *
 * The middle of the base is at origin (0, 0, 0) and the tip of the triangle
 * points along the Y axis. Depth is in the Z axis and is centered on the
 * origin. If depth is not specified it defaults to 2 units.
 */
module triangle(width, height, depth = 2) {
  angle = atan(height / (width / 2));
  difference() {
    translate(v = [ 0, height / 2, 0 ]) {
      cube(size = [ width, height, depth ], center = true);
      }
    translate(v = [ width / 2, 0, 0 ]) {
      rotate(a = [ 0, 0, 90 - angle ]) {
        translate(v = [ width / 2, height, 0 ]) {
          cube(size = [ width, height * 2, depth * 2 ], center = true);
          }
        }
      }
    translate(v = [ -width / 2, 0, 0 ]) {
      rotate(a = [ 0, 0, 270 + angle ]) {
        translate(v = [ -width / 2, height, 0 ]) {
          cube(size = [ width, height * 2, depth * 2 ], center = true);
          }
        }
      }
    }
  }

/** Create an arc
 *
 * Creates a slice of a cylinder that is 'width' along the X axis, 'height'
 * along the Y axis and 'depth' along the Z axis. The base (the flat part)
 * is centered on the origin. If 'depth' is not specified it defaults to
 * 2 units.
 */
module arc(width, height, depth = 2) {
  radius = ((width * width) + (4 * height * height)) / (8 * height);
  difference() {
    translate(v = [ 0, -(radius - height), 0 ]) {
      cylinder(h = depth, r = radius, center = true, $fs = RESOLUTION);
      }
    translate(v = [ 0, -radius, 0 ]) {
      cube(size = [ radius * 2, radius * 2, depth * 2 ], center = true);
      }
    }
  }

/** Calculates the height of a teardrop with a given radius
 */
function teardrop_length(td_radius) = td_radius + sqrt(2 * (td_radius * td_radius));

/** Generate a teardrop shape
 *
 * These shapes are useful for minimising print volume while maintaining
 * structural strength.
 */
module teardrop(td_radius, td_height = 1) {
  translate(v = [ 0, -(teardrop_length(td_radius) - td_radius), 0 ]) {
    rotate(a = [ 0, 0, 45 ]) {
      linear_extrude(height = td_height) {
        union() {
          circle(r = td_radius, $fs = RESOLUTION);
          square(size = [ td_radius, td_radius ]);
          }
        }
      }
    }
  }

/** Variation of the teardrop with a specified length
 *
 * This module allows you to specify the length of the teardrop shape as well
 * as the radius.
 */
module teardrop_scaled(td_radius, td_length, td_height = 1) {
  scale_factor = td_length / teardrop_length(td_radius);
  scale(v = [ 1, scale_factor, 1 ]) {
    teardrop(td_radius, td_height);
    }
  }

/** Create a hexagon.
 *
 * The 'size' parameter specifies the distance from the center of the
 * hexagon to the center of one of the six straight edges. The 'depth'
 * parameter specifies the size in the Z axis. The resulting object
 * is centered on the origin.
 */
module hexagon(length, depth = 2) {
  width = 2 * length * tan(30);
  union() {
    cube(size = [ length * 2, width, depth ], center = true);
    rotate(a = [ 0, 0, 60 ]) {
      cube(size = [ length * 2, width, depth ], center = true);
      }
    rotate(a = [ 0, 0, -60 ]) {
      cube(size = [ length * 2, width, depth ], center = true);
      }
    }
  }

/** Create a hexagon
 *
 * The 'radius' parameter specifies the radius of the smallest circle
 * that contains the hexagon. The 'depth' parameter specifies the size
 * in the Z axis. The resulting object is centered on the origin.
 */
module hexagonR(radius, depth = 2) {
  hexagon(radius * cos(30), depth);
  }

/** Create a hexagon
 *
 * This version of the hexagon module creates a hexagon where each
 * edge is of 'part' length. The 'depth' parameter specifies the
 * size in the Z axis. The resulting object is centered on the
 * origin.
 */
module hexagonL(part, depth = 2) {
  hexagon((part / 2) / tan(30), depth);
  }

/** Create a rounded rectangle
 */
module roundrect(width, height, depth, radius) {
  union() {
     // Make the four corner pieces
     translate(v = [ width / 2 - radius, height / 2 - radius, 0 ]) {
       cylinder(r = radius, h = depth, center = true);
       }
     translate(v = [ width / 2 - radius, -(height / 2 - radius), 0 ]) {
       cylinder(r = radius, h = depth, center = true);
       }
     translate(v = [ -(width / 2 - radius), height / 2 - radius, 0 ]) {
       cylinder(r = radius, h = depth, center = true);
       }
     translate(v = [ -(width / 2 - radius), -(height / 2 - radius), 0 ]) {
       cylinder(r = radius, h = depth, center = true);
       }
    // Add the center rectangles
    cube(size = [ width - (2 * radius), height, depth ], center = true);
    cube(size = [ width, height - (2 * radius), depth ], center = true);
    }
  }