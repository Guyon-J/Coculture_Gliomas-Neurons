# An analysis tool for glioblastoma & neurons coculture 

This tool will propose several worflow process or pre-processing for the analyse of the cancer cells behaviour in a mat of neurons.
Have a look at the project's [JOVE](https://www.jove.com/v/60998/a-3d-spheroid-model-for-glioblastoma) to get more information about the image analysis tools.


## Installation Instructions
In [Fiji](https://fiji.sc/) window, open Plugins > Macros > Startup Macros... and copy and past the code >> __[here](https://github.com/Guyon-J/Coculture_Gliomas-Neurons/blob/main/Macros/Gliomas-Neurons.v1.ijm)__ <<. 
Change the language into IJ1 Macro and save as .ijm file in the Fiji.app folder > macros > toolsets.

Select the tool in the "More Tools" menu (**>>**)


## Tool icons
1. Network Analysis <br> <img align='left' src="https://github.com/Guyon-J/Coculture_Gliomas-Neurons/blob/main/Images/Network.png" height='40'/> The neuronal mat is converted into a simple network and tumor cells are added on the image. It provides information on intercellular contact and cellular morphology. <br><br><hr>
2. Single Cell Tracking Analysis <br> <img align='left' src="https://github.com/Guyon-J/Coculture_Gliomas-Neurons/blob/main/Images/SingleCellTrack.png" height='40'/> Using the shape of the cell migration, one cell can be selected and tracked. <br><br><hr>
3. Multi Cell Tracking (preprocessing) <br> <img align='left' src="https://github.com/Guyon-J/Coculture_Gliomas-Neurons/blob/main/Images/MultiCellTrack.png" height='40'/> Processing steps to binarize the stack and allows its analysis with already developped plugins. <br><br><hr>
4. Spheroid Migration <br> <img align='left' src="https://github.com/Guyon-J/Coculture_Gliomas-Neurons/blob/main/Images/SpheroidMig.png" height='40'/> After delimitation of the pattern, the binarized area occupied by the spheroid is quantified. By relating the area of the spheroide to that of the pattern, we obtain a measure of the confluence. <br><br><hr>




## How to Cite
Guyon, J., Strale, P-O., Romero-Garmendia, I., Bikfalvi, A., Studer, V. and Daubon, T. DOI: [In Revision](https://)




## Compatibility

This toolset was developed on window 10, and tested using ImageJ v1.53. Many features require installation of command line tools that may present future challenges on different operating systems.
