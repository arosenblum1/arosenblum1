# Visualizing Calibration Curves for a Photometric Clinical Chemistry Assay
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
input values. Because of this, a high degree of care must be taken when selecting the analyte concentration
for each cal level. To complicate matters further, the existing software tools used for our splines are too dense and 
user-unfriendly to be effectively used by my team, forcing us to go through the laborious and 
resource-intensive process of making an experimental cal series and collecting a real curve whenever
we want to test a change to the curve's design. 

Using SciPy's handy interpolate module, which includes functions for generating and evaluating spline curves,
I've built several visualizations and tools to explore options for improving cal curve performance for 
a particular problem assay to inform next-step decision-making in the design process.


