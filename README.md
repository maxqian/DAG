# DAG
Directed Automated Gating (DAG) is an algorithm and MATLAB software tool for 2D density-based filtering of flow cytometry data, which performs sequential and hierarchical filtering to identify the cell populations that are of interest and predefined by the user. The output of DAG can be input to a data clustering algorithm such as FLOCK to further segregate cell subsets.

===============================================================================================================================================
Directed Automated Gating (DAG)
August 5, 2015

Rick Stanton (rstanton@humanlongevity.com) - Lead Developer
Alexandra Lee (alee@jcvi.org)
Yu "Max" Qian (mqian@jcvi.org)
Richard H. Scheuermann (rscheuermann@jcvi.org)
Department of Informatics, J. Craig Venter Institute, La Jolla, CA, 92037


INTRODUCTION:

Directed Automated Gating (DAG) is an algorithm and MATLAB software tool for 2D density-based filtering of flow cytometry data, which performs sequential and hierarchical filtering to identify the cell populations that are of interest and predefined by the user. The output of DAG can be input to a data clustering algorithm such as FLOCK to further segregate cell subsets.

This program uses density (contour level) to identify the cell populations.  In order to identify the lymphocyte
population, which is usually a mixture of multiple distributions, a bisecting option based on the density contour level
is provided to recapitulate manual gating results.

An outline of the algorithm can be seen below:

	1.  Fluorescence values are transformed so that all the values are positive
	2.  Fluorescence values are normalized using the maximum value across all channels
	3.  Generate 2D histogram of the data using x-axis and y-axis as defined by the user
	4.  Convolute the histogram with a sine wave, which amplifies the true signal
	5.  If lymphocyte gate
		a.  For each contour level:
			i.  Select the data points that exceed the contour level and are to the right of the left 
			user-defined boundary (bisect)
			ii.  Create an object by connected adjacent data points
			iii.  If the boundaries of the object are completely contained within the user-specified gate 
			then select these data points 
	6.  If not a lymphocyte gate: 
		For each contour level:
			i.  Select the data points that exceed the contour level
			ii.  Create an object by connected adjacent data points
			iii.  If the boundaries of the object are completely contained within the user-specified gate 
			then select these data points 


INSTALLATION:

Programs required for running DAG:

	1.  Download and install MATLAB 7.12.0 (R2011a)


USAGE:

In Linux command line:  "dag_main_cmd(<configuration file path>, <data directory path>, <number of columns for composite>); exit"

In MATLAB: run the dag_main.m by providing parameters values specified in the header

Required Parameters:
	<configuration file path>  
		Path to configuration file, which contains information supplied by the user about the gating and channels
		Configuration file should be saved as a .csv file
		Instructions for filling out the configuration file can be found in "config_template_instructions.xlsx" and "config_template_sample.xlsx"

	<data directory path>
		Path to folder containing all transformed and compensated FSC data files
		Each data file should be saved as a .csv file
		Format of the file is as follows:

		Marker Name 1		Marker Name 2		Marker Name 3		...
		#############		#############		#############		...
		#############		#############		#############		...
		#############		#############		#############		...
		#############		#############		#############		...

		<number of columns for composite>
			A dot plot for each gate and each sample is created, DAG will compile the dot plots for a single gate across all samples
			into a composite image.  This number specifies the number of columns to use for that composite image.


EXAMPLE:

In Linux command line:  matlab -r "dag_main_cmd('/Sample_data/Config/config_101.csv','/Sample_data/Data_101/',2); exit"

DAG will generate several result folders:

filteredData_<Name>
	Contains the florescent intensity data for only those cells that were filtered by the user-specified gates.

filteredPlots
	Contains a dot plot for each gate and each sample as .png

filteredPlotComposites
	Contains compiled dot plots for each gate across all samples as .png

filteredStats
	Contains .txt file with a table listing
	NCellsTotal: number of total cells used
	PopName:  target population name
	NCellsParent:  number of cells in the parent population
	NCellsPop:  number of cells in the target population
	PercentParent:  percent of cells in the target population compared to the parent population

flaggedFiles
	QC is performed so that if a gate does not find any cells then the file is flagged and skipped.  Also if the proportion of cells found
	for a gate is below the user-specified threshold then the file is flagged.
	The name of these files are listed in a .txt file to inform the user
