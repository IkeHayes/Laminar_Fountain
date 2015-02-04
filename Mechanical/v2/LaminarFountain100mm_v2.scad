// ******************************************
// 3D Printed Laminar Fountain 100mm
// By Isaac Hayes
// Copyright 2014
// http://scuttlebots.com
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program; if not, write to the Free Software Foundation, Inc.,
// 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
// ******************************************

// ************************************
// Dimensions and Locations Math(s)
// ************************************

InnerD = 96;	//Inside Diameter
OuterD = 104;	//Outside Diameter
FirstStageZ = 40;	//Height of the first stage (bottom)
FloorZ = 2;		//Thickness of the floor
LipSealZ = 5;	//Height of Lip to seal with next section
WallThickness = 2;	//Thickness of all walls

InletInnerD = 11;	//Hose connector inner diameter
InletOuterD = 13;	//Hose connector outer diameter
InletZ = 16;	//Height of the hose connector
InletX = 62;

StageConnectorOffset = (OuterD/2)-2;	//Distance of bolt mounts from center

SecondStageZ = 75;		//Height of the middle stage (straw section)
InsertOffset = 4;		//Insert overhang in to outer shell (diameter, divide by 2 for radius offset)
InsertGap = 0.18;		//Gap between insert and outershell (diameter, divide by 2 for radius gap)

ThirdStageZ = 35;	//Height of the top (outlet section)
OutletZ = 2;	
OutletD = 9;
OutletDWide = OutletD+OutletZ;

FilterZ = 25.4 / 2;		//Height of the Filter Foam used
FilterLipZ = 0.75;		//Height of the bottom lip holding the filter in place
FilterLipWidth = 4;		//Width of the lip supporting the filter foam

M3ThruHole = 3.5;
M3ThreadHole = 3.25;
M3WasherHole = 6.0;


// ************************************
// Dimensions and Locations Math(s)
// ************************************

module FirstStage()
{
	union() {
		difference()
		{
			union() //main body mass
			{
				cylinder(h=FirstStageZ, d=OuterD, $fn=100); //Outer Shell
				cylinder(h=FirstStageZ+LipSealZ, d=InnerD+WallThickness*2-InsertGap, $fn=100);
				rotate([0,0,45]) {
					translate([0,-9,0]) cube([InletX+(InletOuterD/2+WallThickness),18,18]);	//Inlet Exention
					translate([InletX,0,18]) cylinder(d=InletOuterD,h=InletZ, $fn=100);	//Inlet Pipe
				}
				for(i=[0:90:270]) {		//Stage Connectors w/Hex nut holes
					rotate([0,0,i]) translate([0,StageConnectorOffset,FirstStageZ]) Mount_Bottom(1);
				}
			}
			union()	//negative space (cut outs)
			{
				translate([0,0,FloorZ]) cylinder(h=FirstStageZ+LipSealZ, d=InnerD, $fn=50);	//main body cavity
				rotate([0,0,45]) {
					translate([InletX,0,8]) cylinder(d=InletInnerD,h=InletZ+12.5, $fn=50);	//Inlet Pipe Center Cutout
					translate([0,0,8]) rotate([0,90,0]) cylinder(d=12,h=InletX+(InletOuterD/2), $fn=50);	//Inlet to Main Chamber Cutout
				}
			}
		}
		difference() {		//Flow diverter in center of chamber
			translate([-6,-6,FloorZ]) cube([12,12,12]);
			translate([-8,-8,FloorZ]) cube([12,12,12]);
		}
	}
}

module SecondStage_Shell()
{	
	union() {
		difference() {
			cylinder(d=OuterD,h=SecondStageZ+LipSealZ*2, $fn=100);
			cylinder(d=OuterD-InsertOffset+InsertGap,h=SecondStageZ+LipSealZ*2, $fn=100);
		}
		for(i=[0:90:270]) {
			rotate([0,0,i]) translate([0,StageConnectorOffset,SecondStageZ+LipSealZ*2]) Mount_Bottom(1);
		}
		for(i=[0:90:270]) {
			rotate([0,0,i]) translate([0,StageConnectorOffset,0]) rotate([0,180,0]) Mount_Bottom(0);
		}
	}
}

module SecondStage_Insert()
{
	cylinder(d=InnerD+InsertOffset, h=SecondStageZ, $fn=100);
}

module ThirdStage()
{
	union() {
		difference() {
			//Outer shell minus inner cavity and outlet for water stream
			union() {
				cylinder(d=OuterD, h=ThirdStageZ+OutletZ,$fn=100);
				translate([0,0,-LipSealZ]) cylinder(h=ThirdStageZ+LipSealZ, d=InnerD+WallThickness*2-InsertGap, $fn=100);
			}
			translate([0,0,-LipSealZ]) cylinder(d=InnerD, h=ThirdStageZ+LipSealZ,$fn=100);
			translate([0,0,ThirdStageZ]) cylinder(d1=OutletD,d2=OutletDWide,h=OutletZ,$fn=100);
		}
		for(i=[0:90:270]) {
			rotate([0,0,i]) translate([0,StageConnectorOffset,ThirdStageZ+OutletZ]) rotate([0,180,0]) Mount_Top();
		}
		for(i=[0:90:270]) {
			rotate([0,0,i]) translate([0,StageConnectorOffset,0]) rotate([0,180,0]) Mount_Bottom(0);
		}
	}
}

//Create filter housing for filter foam between first and second stage
module FilterHousing()
{
	difference() {
		cylinder(h=FilterZ+FilterLipZ,d=InnerD-InsertGap,$fn=100);
		cylinder(h=FilterZ+FilterLipZ,d=InnerD-FilterLipWidth*2,$fn=100);
		translate([0,0,FilterLipZ]) cylinder(h=FilterZ,d=InnerD-InsertGap-2,$fn=100);
	}
}

module FountainStand()
{
	SupportX = cos(45) * 80;
	SupportZ = sin(45) * 80;

	union() {
		rotate([0,45,0]) translate([-(OuterD+8)/2,0,0]) {
			intersection() {
				difference() {
					cylinder(h=100, d=OuterD+8, $fn=100);
					translate([0,0,4]) cylinder(h=1000, d=OuterD-InsertGap, $fn=100);
					cylinder(h=110,d=OuterD-20,$fn=100);
				}
				translate([0,-25,0]) cube([80,50,100]);
			}
		}
		translate([0,-5,0]) cube([SupportX,10,4]);
		translate([-5,-30,0]) cube([10,60,4]);
		translate([3,-10,4]) cube([2,20,2]);
		translate([SupportX-10,-50,0]) cube([10,100,4]);
		translate([SupportX-5,-50,4]) cube([2,100,2]);
		translate([SupportX-5,-5,0]) cube([5,10,SupportZ+0.5]);
	}
}

// ************************************
// Functions
// ************************************

//Filter Foam Cutting Guide to help cut filter foam to size
module FilterCutGuide()
{
	difference() {
		cylinder(h=2,d=InnerD-InsertGap-2,$fn=100);
		cylinder(h=2,d=InnerD-InsertGap-22,$fn=100);
	}
}

//Creates a honeycomb pattern of hexagons of a given size and spacing
module HoneyComb(hSize,hSpace,hHeight,N)
{
	hRadius = (hSize/2) / cos(30);
	hYOffset = (hSize + hSpace) * cos(30);
	hXOffset = hSize+hSpace;
	translate([-N*hXOffset,-N*hYOffset,0]) {		
		for (i=[0:N-1]) {
			for (j=[0:(N*2)-1]) {
				translate([(hXOffset*j),i*hYOffset*2,0]) rotate([0,0,30]) cylinder(r=hRadius,h=hHeight,$fn=6);
				translate([(hXOffset*j)+(hXOffset/2),(i*hYOffset*2)+hYOffset,0]) rotate([0,0,30]) cylinder(r=hRadius,h=hHeight,$fn=6);
			}
		}
	}
}

//Mount point to secure lower stages to upper stages via M3 bolt
//bHex = false for round hole, bHex = true for hex nut hole
module Mount_Bottom(bHex)
{
	difference()
	{
		translate([-5,0,0]) rotate([0,90,0]) {
			union()
			{
				translate([0,2,0]) cube([5,10,10]);
				translate([5,2,0]) linear_extrude(height=10) polygon([[0,0],[20,0],[0,10]], convexity=2);
				translate([0,0.5,0]) cube([25,1.5,10]);

			}
		}
		translate([0,7,-24]) cylinder(h=25,d=M3ThruHole,$fn=20);
		if(bHex) {
			translate([0,7,-25]) M3HexHole(20);
		}
		else {
			translate([0,7,-25]) cylinder(h=20,d=6.5, $fn=20);
		}
	}
}

//Mount point to secure uper stages to lower stages via M3 bolt
module Mount_Top()
{
	rotate([0,180,0]) difference()
	{
		translate([-5,0,0]) rotate([0,90,0]) {
			union()		//Solid Section
			{
				translate([0,2,0]) cube([5,10,10]);
				translate([5,2,0]) linear_extrude(height=10) polygon([[0,0],[10,0],[0,10]], convexity=2);
				cube([15,2,10]);
			}
		}
		translate([0,7,-14]) cylinder(h=15,d=M3ThruHole,$fn=20);	//M3 Bolt Through Hole Cutout
		translate([-4,2,-15]) cube([8,10,10]);						//Cutout for M3 Bolt and Washer
	}
}

//Create cutout for an M3 Hex Nut
module M3HexHole(z)
{
	cylinder(d=6.5, h=z, $fn=6);
}

module Test()
{
	difference() {
		cylinder(d=InletOuterD,h=InletZ, $fn=100);
		cylinder(d=InletInnerD,h=InletZ+12.5, $fn=50);
	}
}

// ************************************
// Output for render and export
// ************************************

color("MediumSpringGreen")
{
	//**VISUALIZE RENDERS**
	render(covexity=2) FirstStage();
	translate([0,0,FirstStageZ+20]) render(covexity=2) SecondStage_Shell();
	translate([0,0,FirstStageZ+20+SecondStageZ+20]) render(convexity=2) ThirdStage();
	
	//**STL OUTPUT RENDERS**
	//render(convexity=2) FirstStage();
	//render(convexity=2) SecondStage_Insert();
	//render(convexity=2) SecondStage_Shell();
	//render(convexity=2) ThirdStage();	
	//render(convexity=2) FilterHousing();
	//render(convexity=2) FilterCutGuide();
	//render(convexity=2) FountainStand();

	//**TEST RENDERS**
	//render(covexity=2) HoneyComb(10,1,2,3);
	//render(convexity=4) Mount_Bottom(1);
	//Test();
}

