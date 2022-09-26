---
layout: page
title: "Cluster Analysis of Billionaires"
permalink: /billionaires/
---
### Cluster Analysis of Billionaires

The code for this project was written in R, utlizing ggplot2 and dplyr from the tidyverse stack for data exploration and manipulation. Clustering was performed using the NBClust and dbscan packages.

This was an individual project and is fully my own work.

#### The Data
A dataset of billionaires was compiled and published by Peterson Institute for International Economics, including wealth information in the
years 2001 and 2014 in addition to personal information (age, gender, nation of citizenship) and descriptors for the nature of their wealth
(inherited vs. earned, primary business sector, etc.).
#### Methodology
Two additional features were engineered to incorporate the amount of growth that occurred between 2001 and 2014 in a billionaire’s personal
wealth and their citizenship nation’s GDP as a percentage of their respective 2014 values, as a way of capturing an individual’s wealth growth
during that time period, as well as that of the economy surrounding them.
A density-based clustering algorithm was applied to this dataset to find and interpret different subclasses of billionaire.
#### Results
The two engineered variables turned out to be key for distinguishing
subgroups of billionaires, as can be seen in the scatterplot below. 5
clusters were identified and interpreted as follows:
1. Long-time American billionaires
2. Long-time non-American billionaires
3. New American billionaires
4. New non-American billionaires
5. Chinese billionaires
#### Key Observations
• Long-time non-American billionaires are the wealthiest on average.

• While the US has the most billionaires of any single country, the largest
cluster was populated by the non-American new billionaires.

• The two wealthiest clusters included only 13% of all billionaires,
mirroring the wealth inequality present in the global population.

![Billionaire Clusters Scatterplot](https://github.com/arosenblum1/arosenblum1/blob/gh-pages/Portfolio/Cluster%20Analysis%20of%20Billionaires/AnnotatedVis_BillionaireClusts.png?raw=true)

[[PDF](https://arosenblum1.github.io/arosenblum1/Portfolio/Cluster%20Analysis%20of%20Billionaires/Report%20-%20Billionaires.pdf)]

[[R Code](https://github.com/arosenblum1/arosenblum1/blob/09682ff379479d5fff3b1c50f4337679aaa43a9b/Portfolio/Cluster%20Analysis%20of%20Billionaires/Code%20-%20Billionaires.R)]
