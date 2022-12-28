# Visualizing Calibration Curves for a Photometric Clinical Chemistry Assay
*The following visualizations were created with **matplotlib** in **python**. Spline curves were 
calculated using the **scipy.interpolate** submodule along with **NumPy** for convenience.*

*Concentration values have been scaled by a random constant to maintain project confidentiality.*

## Summary
### Context
In clinical chemistry diagnostics, calibration curves must be collected prior to patient sample 
analysis in order to account for potential differences in materials and testing environment that may affect
the performance of the highly sensitive assays. This involves running the assay with a series of 
control samples (referred to as "cals") whose analyte concentrations are known to correlate the assay's spectrophotometric 
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

### Observing the Impact of Absorbance Variations at Each Calibration Level

The set of graphs below models how small changes in absorbance affect the shape of a calibration curve.
One of the questions I set out to answer was spurred by an instance of an invalid curve generated in the lab due to a negative slope at the curve's
upper end. I was curious which cal levels had the most impact on that part of the curve, and what sort of variations would cause the slope
to go negative, triggering the instrument software to reject the curve as invalid. 

I started with an existing experimental curve (with concentration values scaled by a random constant to maintain confidentiality). 
Then I calculated two hypothetical curves for each cal level by adjusting the absorbance of that cal level up and down by 5%.


![Absorbance](https://github.com/arosenblum1/arosenblum1/blob/gh-pages/Portfolio/CalCurves/abs.png?raw=true)

These graphs show that depressed absorbance values at cal levels 4 and 6 as well as an elevated absorbance at level 5 are all
variations that could possibly lead to a negative slope at the very top of the calibration curve. This indicates that cal level 5, the center of the
curve's problem region, has a sizeable impact on the upper curve's shape. More specifically, the *ratio of cal levels 4, 5, and 6*
is critically important and must be as close to linear as possible to avoid a negative slope.
