# TMS_SAMT_CI
Confidence interval analysis for TMS SAMT

generate_binominal_distributions.m generates results in Data folder for different number of steps. Change parameter on line 2 for different step numbers.

plot_ranges.m creates visualization of all results under Figures folder

Data folder contains results for number of steps between 8 to 22 (.mat, .fig, and .tif files), and only figures for number of steps of 24 due to .mat file size being over 100 MB. 
Rerun generate_binominal_distributions.m with "num_steps = 24;" on line 2 to recreate .mat file

-------------------------------------------------------------------------------------------------------------------------
The copyrights of this software are owned by Duke University. As such, two licenses for this software are offered:

1. An open-source license under the GPLv2 license for non-commercial use.
2. A custom license with Duke University, for commercial use without the GPLv2 license restrictions. 
 
As a recipient of this software, you may choose which license to receive the code under. Outside contributions to the Duke-owned code base cannot be accepted unless the contributor transfers the copyright to those changes over to Duke University.

To enter a custom license agreement without the GPLv2 license restrictions, please contact the Digital Innovations department at the Duke Office for Translation & Commercialization (OTC) (https://olv.duke.edu/software/) at otcquestions@duke.edu with reference to “OTC File No. 8073” in your email.

Please note that this software is distributed AS IS, WITHOUT ANY WARRANTY; and without the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
