//** Created by Guyon Joris, INSERM u1029,
//   Bordeaux University, Pessac, Gironde, October 01, 2020
// 
// This macro was created to faciliate the analysis of Fluorescent Cancer Cells on neural mat from different acquisitions in Fiji.


/*
version 1.0, October 01, 2020
*/

requires("1.53c");

/* *********************************************************************************************************************************** */
/* *********************************************************************************************************************************** */

// Variables
	/// Global
var name;
var name_sp = "SPLIT";
var slice_nb;
var bf = "BF_";
var green = "MB_";
var red = "NU_";
var thsld;
var	GB_radius = 3;
var	M_radius = 5;

var URL = "https://github.com/Guyon-J/Coculture_Gliomas-Neurons/blob/main/README.md" ;

	/// Network
var Particle_sift = 1500;

	/// Single cell tracking
var z_proj;
var name_stack;
var trail_type;
var skip_step = false;
var Particle_sift2 = 1500;
var n0;
var n_Roi;
var n_unique;
var name_cell;

	/// Multi cell tracking preprocessing
var Particle_sift3 = 1000;


/* *********************************************************************************************************************************** */
/* *********************************************************************************************************************************** */


/* ***********************************************************************************************************************************
 *  HELP TOOLSET
 * *********************************************************************************************************************************** 
*/

macro "HELP Action Tool - Cf00D15D16D17D18D19D27D35D36D37D38D39D55D56D57D58D59D65D67D69D75D79D95D96D97D98D99Da9Dc5Dc6Dc7Dc8Dc9Dd5Dd7De5De6De7CbffD00D01D0cD23D4dD4fD5fD63D7bD82D9bDacDc2Dd0DefDf3DfdDffCff8D0bD1bD1dD1fD20D32D33D3cD4bD51D53D7eD8cD8dD90D9cD9fDbdDcdDcfDe2DecDfbCfffD04D05D06D07D08D09D0aD14D1aD24D25D26D28D29D2aD34D3aD44D45D46D47D48D49D4aD54D5aD64D66D68D6aD74D76D77D78D7aD84D85D86D87D88D89D8aD94D9aDa4Da5Da6Da7Da8DaaDb4Db5Db6Db7Db8Db9DbaDc4DcaDd4Dd6Dd8Dd9DdaDe4De8De9DeaDf4Df5Df6Df7Df8Df9DfaCcccD03D0eD22D2dD50D6bD6eD80D8fDafDb1DbeDbfDdbDe0De3Df2DfeCfffD2cD3bD9dDa3Db3DbcDc1CeeeD0dD12D1cD2bD3dD42D43D4cD5cD5dD6cD72D73D7cD7dD83D92D93D9eDa1Da2DadDb2Dc3DccDceDd1Dd3DedC666D8bCdddD02D13D2eD2fD3eD40D41D4eD52D5eD62D6dD70D71D7fD81D8eD91Da0DaeDc0Dd2DdcDddDdeDdfDebCbbbD21D31D3fD61D6fDb0DeeDf1DfcC999DbbC888D0fD30D5bDabCaaaD10D11D1eD60De1C777DcbDf0"{
	run("URL...", "url="+URL);
}

macro "HELP Action Tool Options" {
	run("Arrange Channels...");
}  

/* ***********************************************************************************************************************************
 *  NETWORK ANALYSIS
 * *********************************************************************************************************************************** 
*/

macro "Network Action Tool - C000D01D0aD0bD11D12D1bD22D23D2bD33D34D3bD3eD3fD44D45D46D47D48D49D4aD4bD4dD4eD55D58D5aD5bD5cD5dD60D65D68D6dD70D74D75D78D79D7aD7dD7eD80D81D83D84D85D89D8aD8eD91D93D95D96D9eDa2Da3Da6Da7Da8Da9DaaDaeDb1Db2Db3DbaDbdDbeDc1DcaDcbDccDcdDceDd0Dd1DdeDdfDe0DefCfffD00D02D03D04D05D06D07D08D09D0cD0dD0eD0fD10D13D14D15D16D17D18D19D1aD1cD1dD1eD1fD20D21D24D25D26D27D28D29D2aD2cD2dD2eD2fD30D31D32D35D36D37D38D39D3aD3cD3dD40D41D42D43D4cD4fD50D51D52D53D54D56D57D59D5eD5fD61D62D63D64D66D67D69D6aD6bD6cD6eD6fD71D72D73D76D77D7bD7cD7fD82D86D87D88D8bD8cD8dD8fD90D92D94D97D98D99D9aD9bD9cD9dD9fDa0Da1Da4Da5DabDacDadDafDb0Db4Db9DbbDbcDbfDc0Dc2Dc3Dc4Dc9DcfDd2Dd3Dd4Dd9DdaDdbDdcDddDe1De2De3De4De9DeaDebDecDedDeeDf0Df1Df2Df3Df4Df5Df6Df7Df8Df9DfaDfbDfcDfdDfeDffC2b4Db5Db6Db7Db8Dc5Dc8Dd5Dd8De5De6De7De8C0f4Dc6Dc7Dd6Dd7"{
	name = getTitle();
	run("8-bit");
	Stack.getDimensions(width, height, channels, slices, frames);
	Split();
	slice_nb = getSliceNumber();
	Rename();

	//Network 
	selectWindow(bf);
	run("Duplicate...", "title=BF");
	run("Enhance Contrast...", "saturated=0.3 normalize equalize");  // Contrast Stretch Enhancement
	run("Find Edges");	// Sobel Edge Detector Step
	Filters();	// Filter step
	Mask();	// Binarization
	run("Skeletonize"); run("Dilate");	// Skeletonization
	run("Analyze Particles...", "size="+Particle_sift+"-Infinity show=Masks in_situ");	// Elimination of particles
	ROI_management();
	roiManager("Rename", name+"_slice-"+slice_nb+"_Network");
	selectWindow("BF");
	run("Close");
	
	// Membrane binarization
	selectWindow(green);
	run("Duplicate...", "title=GREEN");
	Filters();
	Mask();
	run("Analyze Particles...", "size="+Particle_sift+"-Infinity show=Masks in_situ");
	ROI_management();
	/*	run("Enlarge...", "enlarge=-2"); roiManager("Update");	*/
	roiManager("Rename", name+"_slice-"+slice_nb+"_Membrane");
	selectWindow("GREEN");
	Morpho_analysis();
	
	// Nucleus binarization
	selectWindow(red);
	run("Duplicate...", "title=RED");
	Filters();
	Mask();
	run("Analyze Particles...", "size="+Particle_sift+"-Infinity show=Masks in_situ");
	ROI_management();
	/*	run("Enlarge...", "enlarge=-10"); roiManager("Update");	*/
	roiManager("Rename", name+"_slice-"+slice_nb+"_Nucleus");
	selectWindow("RED");
	run("Close");

	// Automatic merging
	Merging_network();
	composite = name+"_slice-"+slice_nb+"_merge";
	rename(composite);

	// Back to original
	run("Merge Channels...", "c1=NU_ c2=MB_ c4=BF_ create");
	rename(name);
	setSlice(1+((slice_nb-1)*channels));
	selectWindow(composite);

	Quality_control();
}

macro "Network Action Tool Options" {
	thsld_choice();
	Dialog.create("Network Options");
		Dialog.addChoice("Threshold :", thsld);
		Dialog.addMessage("Filters");
		Dialog.addNumber("Gaussian Blur", GB_radius);
		Dialog.addNumber("Median", M_radius);
		Dialog.addMessage("Particle sift");
		Dialog.addNumber("Min weight (px)", Particle_sift);
	Dialog.show();
	thsld = Dialog.getChoice();
	call("ij.Prefs.set", "dialogDefaults.thsld", thsld);
	GB_radius = Dialog.getNumber();
	M_radius = Dialog.getNumber();
	Particle_sift= Dialog.getNumber();
}

/* ***********************************************************************************************************************************
 *  SINGLE CELL TRACKING
 * *********************************************************************************************************************************** 
*/

macro "Single Cell Tracking Action Tool - C000D00D01D02D03D04D05D06D07D08D09D0aD0bD0cD0dD0eD0fD10D11D12D13D14D15D16D17D18D19D1aD1bD1cD1dD1eD1fD20D21D22D23D24D25D26D27D28D29D2aD2bD2dD2eD2fD30D31D32D33D34D35D36D37D38D39D3aD3eD3fD40D41D42D43D44D45D46D47D48D49D4aD4bD4dD4eD4fD50D51D52D59D5aD5bD5dD5eD5fD60D61D62D69D6aD6bD6dD6eD6fD70D71D72D79D7aD7bD7dD7eD7fD80D81D82D89D8dD8eD8fD90D91D92D99D9aD9bD9cD9dD9eD9fDa0Da1Da2Da9DaaDabDacDadDaeDafDb0Db1Db2Db3Db4Db5Db6Db7Db8Db9DbaDbbDbcDbdDbeDbfDc0Dc1Dc2Dc3Dc4Dc5Dc6Dc7Dc8Dc9DcaDcbDccDcdDceDcfDd0Dd1Dd2Dd3Dd4Dd5Dd6Dd7Dd8Dd9DdaDdbDdcDddDdeDdfDe0De1De2De3De4De5De6De7De8De9DeaDebDecDedDeeDefDf0Df1Df2Df3Df4Df5Df6Df7Df8Df9DfaDfbDfcDfdDfeDffC2b4D53D54D55D56D57D58D63D68D73D78D83D88D93D98Da3Da4Da5Da6Da7Da8CfffD2cD3bD3cD3dD4cD5cD6cD7cD8aD8bD8cC0f4D64D65D66D67D74D75D76D77D84D85D86D87D94D95D96D97"{
	name = getTitle();
	run("8-bit");
	Stack.getDimensions(width, height, channels, slices, frames);
	
	if (skip_step==false) {
		Split();
		Rename();
		if (startsWith(getTitle(), bf)) {
			selectWindow(bf);
			close();
		}
		run("Merge Channels...", "c1="+red+" c2="+green+" create");	
		rename(name);
		T_stack();
		run("Duplicate...", "title=BIN_"+name_stack+" duplicate");
		Split();
		
		// Nucleus trail
		if (trail_type=="Nucleus"){
			selectWindow("C2-"+name_sp);
			close();
			selectWindow("C1-"+name_sp);
			Filters();
			Mask();
			run("Analyze Particles...", "size="+Particle_sift2+"-Infinity show=Masks in_situ");
			run("Median...", "radius="+M_radius);
			n0 = roiManager("count");
			ROI_delete();
			run("Analyze Particles...", "exclude add");
			n_Roi = roiManager("count")-1;
			ROI_rename();
			selectWindow("C1-"+name_sp);
			close();
			selectWindow("T-Stack_"+name);
			close();
		}
		
		// Membrane trail
		if (trail_type=="Membrane"){
			selectWindow("C1-"+name_sp);
			close();
			selectWindow("C2-"+name_sp);
			Filters();
			Mask();
			run("Analyze Particles...", "size="+Particle_sift2+"-Infinity show=Masks in_situ");
			run("Median...", "radius="+M_radius);
			n0 = roiManager("count");
			ROI_delete();
			run("Analyze Particles...", "exclude add");
			n_Roi = roiManager("count")-1;
			ROI_rename();
			selectWindow("C2-"+name_sp);
			close();
			selectWindow("T-Stack_"+name);
			close();
		}

		// Tracking
		run("Clear Results");
		selectWindow(name_stack);
		roiManager("Show All");
		ROI_selection();
		selectWindow(name);
		roiManager("select", n_unique-1);
		run("Duplicate...", "title=Cell_n"+n_unique+" duplicate");
		name_cell = getTitle();
		Split();
		Rename();
		selectWindow(green);
		close();
		selectWindow(red);
		rename(name_cell);
		Filters();
		Mask();
		SingleCell_tracking();
		selectWindow(name);
		selectWindow(name_cell);
	}
	
	if (skip_step==true) {
		// Tracking only
		run("Clear Results");
		selectWindow(name_stack);
		roiManager("Show All");
		ROI_selection();
		selectWindow(name);
		roiManager("select", n_unique-1);
		run("Duplicate...", "title=Cell_n"+n_unique+" duplicate");
		name_cell = getTitle();
		Split();
		Rename();
		selectWindow(green);
		close();
		selectWindow(red);
		rename(name_cell);
		Filters();
		Mask();
		SingleCell_tracking();
		selectWindow(name);
		selectWindow(name_cell);
	}
	plots();
	Quality_control();
}

macro "Single Cell Tracking Action Tool Options" {
	thsld_choice();
	z_proj_choice();
	trail_choice();
	Dialog.create("Single Cell Tracking Options");
		Dialog.addChoice("Trail type", trail_type);
		Dialog.addChoice("Threshold", thsld);
		Dialog.addChoice("Z projection", z_proj); 
		Dialog.addMessage("Filters");
		Dialog.addNumber("Gaussian Blur", GB_radius);	
		Dialog.addNumber("Median", M_radius);
		Dialog.addMessage("Particle sift");
		Dialog.addNumber("Min weight (px)", Particle_sift2);
		Dialog.addCheckbox("Skip edge detection", skip_step);
	Dialog.show();
	trail_type = Dialog.getChoice();
	call("ij.Prefs.set", "dialogDefaults.trail_type", trail_type);
	thsld = Dialog.getChoice();
	call("ij.Prefs.set", "dialogDefaults.thsld", thsld);
	z_proj = Dialog.getChoice();
	call("ij.Prefs.set", "dialogDefaults.z_proj", z_proj);
	GB_radius = Dialog.getNumber();
	M_radius = Dialog.getNumber();
	Particle_sift2 = Dialog.getNumber();
	skip_step = Dialog.getCheckbox();
	//call("ij.Prefs.get", "dialogDefaults.skip_step", skip_step);
}

/* ***********************************************************************************************************************************
 *  MULTI CELL TRACKING PREPROCESSING
 * *********************************************************************************************************************************** 
*/

macro "Tracking Action Tool - C000D00D01D02D03D04D05D06D07D08D09D0aD0bD0cD0dD0eD0fD10D11D18D19D1aD1bD1dD1eD1fD20D21D28D29D2aD2eD2fD30D31D38D39D3aD3bD3dD3eD3fD40D41D48D49D4aD4bD4dD4eD4fD50D51D58D59D5aD5bD5dD5eD5fD60D61D68D69D6aD6bD6dD6eD6fD70D71D72D73D74D75D76D77D78D79D7aD7bD7dD7eD7fD80D81D82D83D85D86D87D88D89D8aD8bD8cD8dD8eD8fD90D91D92D93D95D96D97D98D9fDa0Da1Da2Da3Da5Da7Da8DafDb0Db1Db2Db3Db8DbfDc0Dc1Dc2Dc3Dc4Dc5Dc7Dc8DcfDd0Dd1Dd2Dd3Dd4Dd5Dd6Dd7Dd8DdfDe0De1De2De3De4De5De6De7De8DefDf0Df1Df2Df3Df4Df5Df6Df7Df8Df9DfaDfbDfcDfdDfeDffC2b4D12D13D14D15D16D17D22D27D32D37D42D47D52D57D62D63D64D65D66D67D99D9aD9bD9cD9dD9eDa9DaeDb9DbeDc9DceDd9DdeDe9DeaDebDecDedDeeCfffD1cD2bD2cD2dD3cD4cD5cD6cD7cD84D94Da4Da6Db4Db5Db6Db7Dc6C0f4D23D24D25D26D33D34D35D36D43D44D45D46D53D54D55D56DaaDabDacDadDbaDbbDbcDbdDcaDcbDccDcdDdaDdbDdcDdd"{
	name = getTitle();
	setSlice(1);
	run("8-bit");
	Split();
	Rename();
	if (startsWith(getTitle(), bf)) {
		selectWindow(bf);
		close();
	}

	// Membrane
	selectWindow(green);
	Filters();
	Mask();
	run("Analyze Particles...", "size="+Particle_sift3+"-Infinity show=Masks in_situ stack");

	// Nucleus
	selectWindow(red);
	Filters();
	Mask();
	run("Analyze Particles...", "size="+Particle_sift3+"-Infinity show=Masks in_situ stack");

 	// AND Calculation
 	imageCalculator("AND create stack", green, red);
 	selectWindow(green);
 	close();
 	selectWindow(red);
 	close();
	selectWindow("Result of "+green);
	rename("AND_"+name);	
}

macro "Tracking Action Tool Options" {
	thsld_choice();
	Dialog.create("Multi Cell Tracking Options");
		Dialog.addChoice("Threshold", thsld);
		Dialog.addMessage("Filters");
		Dialog.addNumber("Gaussian Blur", GB_radius);	
		Dialog.addNumber("Median", M_radius);
		Dialog.addMessage("Particle sift");
		Dialog.addNumber("Min weight (px)", Particle_sift3);
	Dialog.show();
	thsld = Dialog.getChoice();
	call("ij.Prefs.set", "dialogDefaults.thsld", thsld);
	GB_radius = Dialog.getNumber();
	M_radius = Dialog.getNumber();
	Particle_sift3 = Dialog.getNumber();
}


/* ***********************************************************************************************************************************
 *  SPHEROID MIGRATION
 * *********************************************************************************************************************************** 
*/

macro "Migration Action Tool - C777D0fD1eD1fD2bD2cD2dD2eD3bD3cD3dD3eD3fD4bD4cD4dD4eD4fD59D5dD5eD5fD68D69D6aD6cD6eD6fD78D79D7aD7bD7dD7eD7fD85D86D89D8aD8bD8dD8eD8fD92D93D94D95D96D99D9aD9bD9cD9dD9eD9fDa2Da3Da4Da6Da7DabDacDadDaeDb1Db2Db3Db4Db5Db6DbaDbbDbcDbdDc1Dc2Dc3Dc4Dc5Dc6Dc9DcaDcbDccDcdDcfDd0Dd1Dd2Dd3Dd4Dd5Dd6Dd7Dd8Dd9DdaDdbDdcDdeDdfDe0De1De2De5De6De7De8De9DecDedDeeDefDf0Df1Df2Df4Df5Df6Df7Df8Df9DfaDfbDfcDfdDfeDffC0f4D00D01D02D03D04D05D06D07D08D09D0aD0bD0cD0dD0eD10D11D12D13D14D15D16D17D18D19D1aD1bD1cD1dD20D21D22D23D24D25D26D27D28D29D2aD2fD30D31D32D33D34D35D36D37D38D39D3aD40D41D42D43D44D45D46D47D48D49D4aD50D51D52D53D54D55D56D57D58D5aD5bD5cD60D61D62D63D64D65D66D67D6bD6dD70D71D72D73D74D75D76D77D7cD80D81D82D83D84D87D88D8cD90D91D97D98Da0Da1Da5Da8Da9DaaDafDb0Db7Db8Db9DbeDbfDc0Dc7Dc8DceDddDe3De4DeaDebDf3"{
	name = getTitle();
	run("Set Measurements...", "area perimeter redirect=None decimal=3");
	run("Clear Results");
	setSlice(1);
	run("8-bit");
	Split();
	Rename();

	// Only 2 channels images : Brighfield and Green
	selectWindow(green);
	rename(bf);
	selectWindow(red);
	rename("BIN_"+name);
	
	// BRIGHFIELD 
	Field_draw();

	// MIGRATION
	selectWindow("BIN_"+name);
	roiManager("Select", 0);
	run("Clear Outside", "stack");
	run("Crop");
	Filters();
	Mask();

	for (i=1; i<=nSlices; i++) {
		run("Create Selection");
		roiManager("Add");
		roiManager("Select", i);
		roiManager("Rename", name+"_area_fr"+i);
		run("Measure");
		run("Next Slice [>]");
	}

	Plot.create("Plot of Results", "x", "Area");
	Plot.add("Circle", Table.getColumn("Area", "Results"));
	Plot.setStyle(0, "blue,#a0a0ff,1.5,Circle");

}

macro "Migration Action Tool Options" {
	thsld_choice();
	Dialog.create("Migration Options");
		Dialog.addChoice("Threshold", thsld);
		Dialog.addMessage("Filters");
		Dialog.addNumber("Gaussian Blur", GB_radius);	
		Dialog.addNumber("Median", M_radius);
	Dialog.show();
	thsld = Dialog.getChoice();
	call("ij.Prefs.set", "dialogDefaults.thsld", thsld);
	GB_radius = Dialog.getNumber();
	M_radius = Dialog.getNumber();
}


/* *********************************************************************************************************************************** */
/* *********************************************************************************************************************************** */


// Functions (alphabetic order)
function Field_draw(){
	selectWindow(bf);
	setTool("polygon");
	waitForUser("Field determination", "Draw a square around the pattern, then click ok");
	roiManager("Add");
	n = roiManager("count");	
	roiManager("Select", n-1);
	roiManager("Rename", "Field");
	run("Measure");
	selectWindow(bf);
	close();
}

function Filters() {
	run("Gaussian Blur...", "sigma="+GB_radius+" stack"); 	
	run("Median...", "radius="+M_radius+" stack");			
}


function Initialization(){
	//Clear result window
	run("Clear Results");
	
	// Close the log window
	if( isOpen("Log") ) {
	selectWindow("Log");
	run("Close");
	}
	// Close ROI manager
	if( isOpen("ROI Manager") ) {
	selectWindow("ROI Manager");
	run("Close");
	}
}


function Mask() {
	setAutoThreshold(thsld);
	run("Convert to Mask", "method="+thsld+" calculate"); 
}


function Merging_network(){
	selectWindow("GREEN");
	rename(name+"_merge");
	run("RGB Color");
	n = roiManager("count");
	roiManager("Select", n-2);
	setForegroundColor(0, 255, 0);
	roiManager("Fill");
	n = roiManager("count");
	roiManager("Select", n-1);
	setForegroundColor(255, 0, 0);
	roiManager("Fill");
	n = roiManager("count");
	roiManager("Select", n-3);
	setForegroundColor(0, 0, 0);
	roiManager("Fill");
}


function Morpho_analysis(){
	run("Duplicate...", " ");
	run("Set Measurements...", "area perimeter shape redirect=None decimal=3");
	run("Analyze Particles...", "size="+Particle_sift+"-Infinity display");
	close();
}


function plots(){
	Plot.create("Plot of Results", "X", "Y");
	Plot.add("Circle", Table.getColumn("X", "Results"), Table.getColumn("Y", "Results"));
	Plot.setStyle(0, "blue,#a0a0ff,1.5,Connected Circles");
	Plot.setAxisLabelSize(14.0, "bold");
	Plot.setFontSize(14.0);
	Plot.setXYLabels("X", "Y");
	Plot.setFormatFlags("11001100111111");
}

function Quality_control(){
	print("Experiment:", name+"_slice-"+slice_nb);	
	print("   ");
	print("Parameters used");
	print("     Gaussian Blur radius:", GB_radius);
	print("     Median radius:", M_radius);
	print("     Threshold:", thsld);
	print("   ");
	print("   ");
}


function ROI_delete(){
	if (n0 > 0) {
		run("Select All");
		roiManager("Deselect");
		roiManager("Delete");
	}		
}


function ROI_management(){
	run("Create Selection");
	roiManager("Add");
	n = roiManager("count");
	roiManager("Select", n-1);
}


function ROI_rename(){
	for (i=0; i <= n_Roi; i++) {
		roiManager("Select", i);
		roiManager("Rename", name+"_n"+i+1);
	}
}


function ROI_selection(){
	Dialog.create("enter some rois");
		Dialog.addMessage("Select one ROI:");
		Dialog.addNumber(name+"_n", 1);
		Dialog.show();
	n_unique = Dialog.getNumber();
}


function Rename(){
	altname = getTitle();
	if (startsWith(altname, "C3-"+name_sp)){
		selectWindow("C3-"+name_sp);
		rename(bf);
		run("Put Behind [tab]");
	}
	altname = getTitle();
	if (startsWith(altname, "C2-"+name_sp)){
		selectWindow("C2-"+name_sp);
		rename(green);
		run("Put Behind [tab]");
	}
	altname = getTitle();
	if (startsWith(altname, "C1-"+name_sp)){
		selectWindow("C1-"+name_sp);
		rename(red);
		run("Put Behind [tab]");
	}
}


function SingleCell_tracking(){
	run("Set Measurements...", "centroid redirect=None decimal=3");
	// nr0 = nResults;
	run("Analyze Particles...", "display stack");
	// nri = nResults;
	// nrd = nri-nr0;
	// for (i=nr0, n=1 ; n<nrd; i++ , n+1){
	//	setResult("Cell_Number", i, name_cell);
	//}
	//updateResults();
}


function Split(){
	rename(name_sp);
	run("Split Channels");
}


function T_stack(){
	run("Duplicate...", "title=T-Stack_"+name+" duplicate");
	run("Enhance Contrast", "saturated=0.35");
	run("Apply LUT", "stack");
	run("Z Project...", "projection=["+z_proj+"]");
	name_stack = getTitle();
}


function trail_choice(){
	Atr = "Nucleus";
	Btr = "Membrane";
	trail_type = newArray(Atr, Btr);	// Listing components
	if ( call("ij.Prefs.get", "dialogDefaults.trail_type", Atr) ==  Atr) trail_type = newArray(Atr, Btr);
	if ( call("ij.Prefs.get", "dialogDefaults.trail_type", Atr) ==  Btr) trail_type = newArray(Btr, Atr);
}


function thsld_choice(){
	At = "Default dark";
	Bt = "Huang dark";
	Ct = "IsoData dark";
	Dt = "Li dark";
	Et = "Mean dark";
	Ft = "Triangle dark";
	Gt = "Yen dark";
	thsld = newArray(At, Bt, Ct, Dt, Et, Ft, Gt);	 // listing thresholds
	if ( call("ij.Prefs.get", "dialogDefaults.thsld", At) ==  At) thsld = newArray(At, Bt, Ct, Dt, Et, Ft, Gt);
	if ( call("ij.Prefs.get", "dialogDefaults.thsld", At) ==  Bt) thsld = newArray(Bt, At, Ct, Dt, Et, Ft, Gt);
	if ( call("ij.Prefs.get", "dialogDefaults.thsld", At) ==  Ct) thsld = newArray(Ct, At, Bt, Dt, Et, Ft, Gt);
	if ( call("ij.Prefs.get", "dialogDefaults.thsld", At) ==  Dt) thsld = newArray(Dt, At, Bt, Ct, Et, Ft, Gt);
	if ( call("ij.Prefs.get", "dialogDefaults.thsld", At) ==  Et) thsld = newArray(Et, At, Bt, Ct, Dt, Ft, Gt);
	if ( call("ij.Prefs.get", "dialogDefaults.thsld", At) ==  Ft) thsld = newArray(Ft, At, Bt, Ct, Dt, Et, Gt);
	if ( call("ij.Prefs.get", "dialogDefaults.thsld", At) ==  Gt) thsld = newArray(Gt, At, Bt, Ct, Dt, Et, Ft);
}


function z_proj_choice(){
	Az = "Max Intensity";
	Bz = "Average Intensity";
	Cz = "Min Intensity";
	Dz = "Sum Slices";
	Ez = "Standard Deviation";
	Fz = "Median";
	z_proj = newArray(Az, Bz, Cz, Dz, Ez, Fz);	 // listing projection types
	if ( call("ij.Prefs.get", "dialogDefaults.z_proj", Az) ==  Az) z_proj = newArray(Az, Bz, Cz, Dz, Ez, Fz);
	if ( call("ij.Prefs.get", "dialogDefaults.z_proj", Az) ==  Bz) z_proj = newArray(Bz, Az, Cz, Dz, Ez, Fz);
	if ( call("ij.Prefs.get", "dialogDefaults.z_proj", Az) ==  Cz) z_proj = newArray(Cz, Az, Bz, Dz, Ez, Fz);
	if ( call("ij.Prefs.get", "dialogDefaults.z_proj", Az) ==  Dz) z_proj = newArray(Dz, Az, Bz, Cz, Ez, Fz);
	if ( call("ij.Prefs.get", "dialogDefaults.z_proj", Az) ==  Ez) z_proj = newArray(Ez, Az, Bz, Cz, Dz, Fz);
	if ( call("ij.Prefs.get", "dialogDefaults.z_proj", Az) ==  Fz) z_proj = newArray(Fz, Az, Bz, Cz, Dz, Ez);
}
