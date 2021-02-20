# An analysis tool for glioblastoma & neuron coculture 

This tool proposes several worflow processes for analyzing cancer cells behaviors on a neuronal network.
Have a look at the project's [JOVE](https://www.jove.com/v/60998/a-3d-spheroid-model-for-glioblastoma) to get more information about the image analysis tools.


## Installation Instructions
In [Fiji](https://fiji.sc/) window, open Plugins > Macros > Startup Macros... and copy and past the code >> __[here](https://github.com/Guyon-J/Coculture_Gliomas-Neurons/blob/main/Macros/Gliomas-Neurons.v1.ijm)__ <<. 
Change the language into IJ1 Macro and save as .ijm file in the Fiji.app folder > macros > toolsets.

Select the tool in the "More Tools" menu (**>>**)


## Tool icons
1. Network Analysis <br> <img align='left' src="https://github.com/Guyon-J/Coculture_Gliomas-Neurons/blob/main/Images/Network.png" height='40'/> The neuronal mat is converted into a simple network and tumor cells are added on the image. It provides information on intercellular contact and cellular morphology. <br><br><hr>
2. Single Cell Tracking Analysis <br> <img align='left' src="https://github.com/Guyon-J/Coculture_Gliomas-Neurons/blob/main/Images/SingleCellTrack.png" height='40'/> Using the shape of the cell migration, one cell can be selected and tracked. <br><br><hr>
3. Multi Cell Tracking (preprocessing) <br> <img align='left' src="https://github.com/Guyon-J/Coculture_Gliomas-Neurons/blob/main/Images/MultiCellTrack.png" height='40'/> Processing steps to binarize the stack and allows its analysis with already developped plugins. <br><br><hr>
4. Spheroid Migration <br> <img align='left' src="https://github.com/Guyon-J/Coculture_Gliomas-Neurons/blob/main/Images/SpheroidMig.png" height='40'/> After delimitation of the pattern, the binarized area occupied by the spheroid is quantified. By relating the area of the spheroid to that of the pattern, we obtain a measure of the confluence. <br><br><hr>




## How to Cite
<br> [<img align='right' src="https://www.jove.com/img/logo_share.jpg" height='75'/>](https://www.jove.com)
<div itemscope itemtype="https://schema.org/Person"><a itemprop="sameAs" content="https://orcid.org/0000-0001-6692-2890" href="https://orcid.org/0000-0001-6692-2890" target="orcid.widget" rel="me noopener noreferrer" style="vertical-align:top;"><img src="https://orcid.org/sites/default/files/images/orcid_16x16.png" style="width:1em;margin-right:.5em;" alt="ORCID iD icon">Guyon, J.</a>, Strale, P-O., Romero-Garmendia, I., Bikfalvi, A., Studer, V. and < itemscope itemtype="https://schema.org/Person"><a itemprop="sameAs" content="https://orcid.org/0000-0002-0319-7617" href="https://orcid.org/0000-0002-0319-7617" target="orcid.widget" rel="me noopener noreferrer" style="vertical-align:top;"><img src="https://orcid.org/sites/default/files/images/orcid_16x16.png" style="width:1em;margin-right:.5em;" alt="ORCID iD icon">Daubon, T.</a> DOI: [In Revision](https://). <br>



## Compatibility

This toolset was developed on window 10, and tested using ImageJ v1.53. Many features require installation of command line tools that may present future challenges on different operating systems.
