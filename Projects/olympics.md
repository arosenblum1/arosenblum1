# Visualizing Trends in the Olympic Games Over Time
*Below is a pair of visualizations created as part of a project submission for a Data Visualization course.
The dataset is a complete record of participation in the Olympic Games since the commencement of their modern
incarnation in 1896, where every row is an athlete's participation in a single event.*

*The visualizations were created in **R** using **ggplot2** with **dplyr** for convenience.*

## Proportional Participation by Sport over Time
![sports-over-time](https://github.com/arosenblum1/arosenblum1/blob/gh-pages/Portfolio/Visualizing%20Trends%20in%20the%20Olympic%20Games%20Over%20Time/sports-over-time.PNG?raw=true)
### Description
This visualization is a line graph representing the number of unique participants in each sport over time
as a proportion of the total participants in the Olympics that year. Data is limited to the 5 sports with the
highest participation across all 120 years of data, where each sport is a different color. It was made using
ggplot2 in R, with smoothing applied via loess regression.

### Insights
There are a few noteworthy insights to be drawn from this visualization that tell a compelling
story. The rise and fall of Gymnastics is the most obvious and dramatic of these, peaking in the mid-20th
century with participation above 20% of the entire Games and then dropping steadily until the 2016
Games, last in the dataset, where it ends around 7%. Meanwhile, Swimming had steady representation of
about 5% – 7% up through 1950 before having a sharp, sudden increase in representation between about
1960 – 1976 up to 12% where it remains for the remainder of the time shown. This sharp increase follows
the decline in Gymnastics by about 10 years. Athletics (modernly referred to as "Track and Field") starts and ends at the top, being overtaken only
briefly by Gymnastics during its peak. As it is the all-time most represented Olympic sport (most likely due
to it’s huge breadth of diverse events), this highlights just how dramatic a journey Gymnastics had gone
on. Shooting started off very popular but fell off sharply early on. Cycling has been steadily represented
throughout modern olympic history, declining slightly as more sports are added to the Summer Games.

The only one of these changes that was well explained when researched was Swimming, for
which several technological advances took place including indoor pools and more dynamic material for
swimwear. These changes led to a higher standard of competition and subsequently increased public
interest in the sport as records were broken repeatedly, leading to the culture of superstar swimmers we
see today. (Source: https://olympics.com/en/news/the-history-of-olympic-swimming)

## Proportional Participation by Age over Time
![age-over-time](https://github.com/arosenblum1/arosenblum1/blob/gh-pages/Portfolio/Visualizing%20Trends%20in%20the%20Olympic%20Games%20Over%20Time/age-over-time.PNG?raw=true)
### Description
This visualization is a heatmap of athlete’s ages over time, with a moving average calculated with loess
regression overlaid. Color is mapped to the proportion of each age represented in a given year. It was
made with ggplot2 in R. Originally, this visualization had Age tracked by Sport instead of Year. However,
there wasn’t really anything interesting to see there, and it proved hard to read. After that change was
made, adding the moving average was an obvious next step to take to illustrate the trend more clearly.
Additionally, there are several athletes over the age of 70 which had to be excluded from view in order to
better read the interesting part of the visualization. Finally, because color is mapped to a numerical
variable, the viridis color palette was chosen for its readability.

### Insights
The visualization shows that the highest proportion of athletes have been in their early-to-mid 20’s
throughout modern olympic history, with the distribution tightening over time until about the 1980’s when it
began to widen out again. Average age rose steadily from the 1896 Games, hit its high of about age 39
around 1936, then fell steadily until leveling off around the year 2000 at age 35. 

Immediately notable are the gaps for the years 1916, 1940, and 1944, where the games were not held due to 
World Wars I and II, respectively. One can also make the grim observation that the years immediately following
these gaps (1920 and 1948, respectively) have lower concentrations of athletes in their early 20's than the rest
of the Games' history, an indicator that many of the world's top athletes who would have participated in those
Games instead lost their lives (or otherwise their physical ability to compete) to those terrible wars.
