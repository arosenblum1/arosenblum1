# Exploring Calibration Curve Stability for a Photometric Clinical Chemistry Assay
*The following visualizations were created in **python** with **matplotlib**. Spline curves were 
calculated using the **scipy.interpolate** submodule along with **NumPy** for convenience.*

*Concentration values have been scaled by a random constant to maintain project confidentiality.*

## Summary
### Context
In clinical chemistry diagnostics, calibration (cal) curves must be collected prior to patient sample 
analysis in order to account for potential differences in materials and testing environment that may affect
the performance of the highly sensitive assays. This involves running the assay with a series of 
control samples whose analyte concentrations are known to correlate the assay's spectrophotometric 
response ("absorbance") with a range of sample analyte concentrations. 

Because absorbance often scales non-linearly with assay concentration, many assays utilize a cubic 
spline curve calculation to maintain accuracy across a wide range of analyte concentrations. However,
the mathematics behind splines are complex and can sometimes react unpredictably to small changes in
input values. Because of this, a high level of care must be taken when selecting the analyte concentration
for each cal level.


