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

InnerD = 95;	//Inside Diameter
OuterD = 105;	//Outside Diameter
FirstStageZ = 50;	//Height of the first stage (bottom)
FloorZ = 5;		//Thickness of the floor

ORingD = 2.5;	//Diameter of the o-ring seal between stages
//ORingX = (((OuterD-InnerD) / 2) + InnerD) / 2 ;		//X Position of the O-Ring channel
ORingX = 50.5;

InletInnerD = 11;	//Hose connector inner diameter
InletOuterD = 13;	//Hose connector outer diameter
InletGripD = 11.5;	//Grip around the diameter
InletZ = 16;	//Height of the hose connector

StageConnectorOffset = (OuterD/2)-2;	//Distance of bolt mounts from center

SecondStageZ = 75;		//Height of the middle stage (straw section)
InsertOffset = 2;		//Insert overhang in to outer shell (diameter, divide by 2 for radius offset)
InsertGap = 0.2;		//Gap between insert and outershell (diameter, divide by 2 for radius gap)

ThirdStageZ = 35;	//Height of the top (outlet section)
OutletZ = 2;	
OutletD = 9;
OutletDWide = OutletD+OutletZ;

M3ThruHole = 3.5;
M3ThreadHole = 3.25;
M3WasherHole = 6.0;


// ************************************
// Dimensions and Locations Math(s)
// ************************************

module FirstStage()
{
	difference()
	{
		union() //main body mass
		{
			cylinder(h=FirstStageZ, d=OuterD, $fn=100); //Outer Shell
			translate([20,25,0]) cube([40,20,20]);	//Inlet Exention
			translate([50,35,20]) cylinder(d=InletOuterD,h=InletZ, $fn=100);	//Inlet Pipe
			for(i=[0:90:270]) {		//Stage Connectors w/Hex nut holes
				rotate([0,0,i]) translate([0,StageConnectorOffset,FirstStageZ]) Mount_Bottom(1);
			}
		}
		union()	//negative space (cut outs)
		{
			translate([0,0,FloorZ]) cylinder(h=FirstStageZ-FloorZ, d=InnerD);	//main body cavity
			translate([0,0,FirstStageZ]) rotate_extrude(convexity = 10, $fn=50) translate([ORingX, 0, 0]) circle(d = ORingD, $fn=50);	//Oring Channel
			translate([50,35,12.5]) cylinder(d=InletInnerD,h=InletZ+12.5, $fn=50);	//Inlet Pipe Center Cutout
			translate([20,35,11]) rotate([0,90,0]) cylinder(d=12,h=37, $fn=50);	//Inlet to Main Chamber Cutout
		}
	}
}

module SecondStage_Full()
{
	difference() {	
		union() {
			difference()
			{
				cylinder(d=OuterD,h=SecondStageZ, $fn=100);
				cylinder(d=InnerD,h=SecondStageZ, $fn=100);
			}
			difference()
			{
				cylinder(d=InnerD,h=SecondStageZ, $fn=100);
				HoneyComb(5,0.5,SecondStageZ,11);
			}
			//First Stage Connectors
			translate([0,StageConnectorOffset,0]) Mount_Top();
			rotate([0,0,90]) translate([0,StageConnectorOffset,0]) Mount_Top();
			rotate([0,0,180]) translate([0,StageConnectorOffset,0]) Mount_Top();
			rotate([0,0,270]) translate([0,StageConnectorOffset,0]) Mount_Top();
			//Third Stage Connectors
			translate([0,StageConnectorOffset,SecondStageZ]) Mount_Bottom();
			rotate([0,0,90]) translate([0,StageConnectorOffset,SecondStageZ]) Mount_Bottom();
			rotate([0,0,180]) translate([0,StageConnectorOffset,SecondStageZ]) Mount_Bottom();
			rotate([0,0,270]) translate([0,StageConnectorOffset,SecondStageZ]) Mount_Bottom();
		}
		translate([0,0,SecondStageZ]) rotate_extrude(convexity = 10, $fn=50) translate([ORingX, 0, 0]) circle(d = ORingD, $fn=50);	//Oring Channel
	}
}

module SecondStage_Shell()
{
	difference() {	
		union() {
			difference()
			{
				cylinder(d=OuterD,h=SecondStageZ, $fn=100);
				cylinder(d=InnerD+InsertOffset+InsertGap,h=SecondStageZ, $fn=100);
			}
			//First Stage Connectors
			// translate([0,StageConnectorOffset,0]) Mount_Top();
			// rotate([0,0,90]) translate([0,StageConnectorOffset,0]) Mount_Top();
			// rotate([0,0,180]) translate([0,StageConnectorOffset,0]) Mount_Top();
			// rotate([0,0,270]) translate([0,StageConnectorOffset,0]) Mount_Top();
			//Third Stage Connectors
			translate([0,StageConnectorOffset,SecondStageZ]) Mount_Bottom(1);
			rotate([0,0,90]) translate([0,StageConnectorOffset,SecondStageZ]) Mount_Bottom(1);
			rotate([0,0,180]) translate([0,StageConnectorOffset,SecondStageZ]) Mount_Bottom(1);
			rotate([0,0,270]) translate([0,StageConnectorOffset,SecondStageZ]) Mount_Bottom(1);
			for(i=[0:90:270]) {
				rotate([0,0,i]) translate([0,StageConnectorOffset,0]) rotate([0,180,0]) Mount_Bottom(0);
			}
		}
		translate([0,0,SecondStageZ]) rotate_extrude(convexity = 10, $fn=50) translate([ORingX, 0, 0]) circle(d = ORingD, $fn=50);	//Oring Channel
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
			cylinder(d=OuterD, h=ThirdStageZ+OutletZ,$fn=100);
			cylinder(d=InnerD, h=ThirdStageZ,$fn=100);
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

// ************************************
// Functions
// ************************************

//Create hose grips that surrount an inlet
module HoseGrip(N,D,L)
{
	for (i=[1:N]){	
		translate([(i-1)*L,0,0]){
			rotate([0,90,0]){	
				rotate_extrude(convexity = 10){
					translate([D, 0, 0]){
						polygon(points=[[0,0],[1,0],[0,L]]);
					}
				}
			}
		}
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
				cube([25,2,10]);

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
	// render(covexity=2) FirstStage();
	// translate([0,0,FirstStageZ+20]) render(covexity=2) SecondStage_Full();
	// translate([0,0,FirstStageZ+20+SecondStageZ+20]) render(convexity=2) ThirdStage();
	
	//**STL OUTPUT RENDERS**
	render(covexity=2) FirstStage();
	//render(covexity=2) SecondStage_Full();
	//render(covexity=2) SecondStage_Insert();
	//render(covexity=2) SecondStage_Shell();
	//render(convexity=2) ThirdStage();	

	//**TEST RENDERS**
	//render(covexity=2) HoneyComb(10,1,2,3);
	//render(convexity=4) Mount_Top();
	//Test();
}

