install.packages("qcc")

library(ggplot2)
library(tidyverse)
library(fastDummies)
library(cluster)
library(clustertend)
library(NbClust)
library(factoextra)
library(fpc)
library(dbscan)
library(dplyr)
library(qcc)
library(moments)
library(RColorBrewer)


### Pull in data and examine
df = read.csv('billionaires.csv', stringsAsFactors = T)
summary(df)

str(df)
str(df$rank)

hist(df$demographics.age)         # Many ages at or below zero, aka missing values






### Dealing with demographics.age missing values ###


length(which(df$year == 2014 & df$demographics.age <= 0))             # 63 missing ages for 2014
df$name[which(df$year == 2014 & df$demographics.age <= 0)]            # Several pairs (siblings, married couples), many individuals

df[which(df$year == 2014 & df$demographics.age <= 0), c(1,11,9)]      # We will drop all of them

df_2014 = df[which(df$year == 2014 & df$demographics.age > 0),]       # New data-frame is made
which(df_2014$year == 2014 & df_2014$demographics.age <= 0)

str(df_2014)
summary(df_2014)


### Dealing with company.founded missing values ###

df_2014[which(df_2014$company.founded == 0),c(1,4,5:10)]
nrow(df_2014[which(df_2014$company.founded == 0),])                                               # Only 12, easy enough to look up individually
                                                                                                  # 3 of the 12 have no company name, so will be removed
df_2014$company.founded[which(df_2014$company.name == "Kiyevskaya Ploshad")] = 1995
df_2014$company.founded[which(df_2014$company.name == "Ruentex Group")] = 1943
df_2014$company.founded[which(df_2014$company.name == "Topland Group")] = 1991
df_2014$company.founded[which(df_2014$company.name == "Air Eye Hospital Group")] = 2003
df_2014$company.founded[which(df_2014$company.name == "Lancing Motor")] = 1993
df_2014$company.founded[which(df_2014$company.name == "Premier Investments")] = 1987
df_2014$company.founded[which(df_2014$company.name == "New Century Group")] = 1988
df_2014$company.founded[which(df_2014$company.name == "Blue Ray Corp")] = 1993

df_2014 = df_2014[-which(df_2014$company.founded == 0),] 

summary(df_2014)






  

### Setting up pct.wealth.since.XXXX variables ###

length(names(df_2014))
names(df_2014)
head(df_2014)

df_2014$wealth.in.2001 = 0
df_2014$wealth.in.1996 = 0
df_2014$pct.wealth.since.2001 = 0
df_2014$pct.wealth.since.1996 = 0



levels(df$year)
df$year = as.factor(df$year)
summary(df$year)

df_2001 = df[which(df$year == "2001"),]
df_1996 = df[which(df$year == "1996"),]


summary(df_2001)
head(df_2001[,c(1,16)])

summary(df_1996)



for (billionaire in seq(1:nrow(df_2014))) {                         # This for loop first checks if a 2014 billionaire is also represented in 2001 and 1996
                                                                    # If they are, their net worth from the year in question is added to their entry for 2014 as a new attribute
  wealth.2014 = df_2014[billionaire, 16]                            # Finally, additional attributes are calculated to represent what percentage of their 2014 net worth came after 2001 and 1996
  wealth.2001 = 0                                                   # These last attributes are calculated for every entry, so if a billionaire is not in the 2001 or 1996 dataframe, their percentage since those years is 100
  wealth.1996 = 0
  
  if(df_2014$name[billionaire] %in% df_2001$name) {
    
    wealth.2001 = df_2001[which(df_2001$name == df_2014[billionaire, 1]), 16]
    df_2014[billionaire, 23] = wealth.2001
    
  }
  
  if(df_2014$name[billionaire] %in% df_1996$name) {
    
    wealth.1996 = df_1996[which(df_1996$name == df_2014[billionaire, 1]), 16]
    df_2014[billionaire, 24] = wealth.1996
    
  }
  
  df_2014[billionaire, 25] = ((wealth.2014 - wealth.2001) / wealth.2014) * 100
  df_2014[billionaire, 26] = ((wealth.2014 - wealth.1996) / wealth.2014) * 100
  
  
}

head(df_2014)
summary(df_2014)


### Arranging GDP Dataset ####

gdp = read.csv('GDPs.csv')
names(gdp)[1] = "Country.Name"
names(gdp)

summary(df_2014$location.gdp)
summary(df_2001$location.gdp)
summary(df_1996$location.gdp)


levels(df_2014$location.citizenship)[-which(levels(df_2014$location.citizenship) %in% gdp$Country.Name)]      # Several countries of billionaires with mismatched names for GDP dataset, or country is simply missing
                                                                                                              # Most will be fixed, adjusted, or removed.
gdp[which(gdp$Country.Name == "Egypt, Arab Rep."), 1] = "Egypt"
gdp[66, 1]

df_2014[which(df_2014$location.citizenship == "Guernsey"), 1:2]                                               # Guernsey is a territory of the UK, so the UK's GDP will be used
df_2014$location.citizenship[which(df_2014$location.citizenship == "Guernsey")] = "United Kingdom"
df_2014[713, c(1,11)]


gdp[which(gdp$Country.Name == "Hong Kong SAR, China"), 1] = "Hong Kong"
gdp[which(gdp$Country.Name == "Hong Kong SAR, China"), 1]
which(gdp$Country.Name == "Hong Kong")

df_2014[(which(df_2014$location.citizenship == "Macau")),]
df_2014 = df_2014[-(which(df_2014$location.citizenship == "Macau")),]                                         # Only a single entry for Macau so it will simply be removed

gdp[which(gdp$Country.Name == "Russian Federation"),1] = "Russia"
gdp[which(gdp$Country.Name == "Russian Federation"),1]
gdp[which(gdp$Country.Name == "Russia"),]

gdp[which(gdp$Country.Name == "Korea, Rep."),1] = "South Korea"
gdp[which(gdp$Country.Name == "South Korea"),]

gdp[which(gdp$Country.Name == "Eswatini"),1] = "Swaziland"
gdp[which(gdp$Country.Name == "Swaziland"),]

df_2014[(which(df_2014$location.citizenship == "Taiwan")),]
length((which(df_2014$location.citizenship == "Taiwan")))

taiwan = data.frame(matrix(ncol=ncol(gdp)))
names(taiwan) = names(gdp)
taiwan$Country.Name = "Taiwan"                                                                                # Since there are so many billionaires from Taiwan (25), this missing GDP was 
taiwan$X1996 = 292494000000                                                                                   # pulled from a different source and entered into the data-frame manually.
taiwan$X2001 = 299276000000                                                                                   # Source: https://countryeconomy.com/gdp/taiwan?year=2014#:~:text=The%20GDP%20figure%20in%202014,in%202013%2C%20it%20was%20%2421%2C945.
taiwan$X2014 = 535328000000

gdp = rbind(gdp, taiwan)

gdp[which(gdp$Country.Name == "Venezuela, RB"),1] = "Venezuela"
gdp[which(gdp$Country.Name == "Venezuela"),]


levels(df_2014$location.citizenship)[-which(levels(df_2014$location.citizenship) %in% gdp$Country.Name)]      # All countries now represented. Guernsey and Macau still appear here, but there are no longer billionaires with these countries as values

summary(gdp)




### Merging GDP data with billionaires data ###



df_2014$location.gdp.2014 = 0
df_2014$location.gdp.2001 = 0
df_2014$location.gdp.1996 = 0
names(df_2014)[27:29]




summary(df_2014[,27:29])

for (billionaire in seq(1:nrow(df_2014))) {
  
  country = df_2014$location.citizenship[billionaire]
  df_2014$location.gdp.2014[billionaire] = gdp$X2014[which(gdp$Country.Name == country)]
  df_2014$location.gdp.2001[billionaire] = gdp$X2001[which(gdp$Country.Name == country)]
  df_2014$location.gdp.1996[billionaire] = gdp$X1996[which(gdp$Country.Name == country)]
  
}


head(df_2014)[,c(1, 16, 23:29)]

df_2014$pct.gdp.since.2001 =                                                                      # Add variables to measure pct of 2014 gdp is new since 2001 and 1996
  ((df_2014$location.gdp.2014 - df_2014$location.gdp.2001) / df_2014$location.gdp.2014) * 100

df_2014$pct.gdp.since.1996 = 
  ((df_2014$location.gdp.2014 - df_2014$location.gdp.1996) / df_2014$location.gdp.2014) * 100


head(df_2014)[,c(1, 16, 23:31)]


### Handling the categoricals ###


str(df_2014)
summary(df_2014)

df_2014$wealth.is.inherited = (df_2014$wealth.type == 'inherited')
df_2014$company.is.founder = (df_2014$company.relationship == 'founder')
df_2014$wealth.how.is.financial = (df_2014$wealth.how.category == 'Financial')
df_2014$is.female = (df_2014$demographics.gender == 'female')

summary(df_2014)



# Creating a Pareto Chart for location.citizenship

country.count = count(df_2014, location.citizenship, sort = T)
country.count

count = country.count$n
names(count) = country.count$location.citizenship

par(mfrow = c(1,1), mar = c(4,1,1,1))
pareto.chart(count, 
             main = "Pareto Chart - Billionaires' Country of Citizenship")



### Variable Scaling and Transforming ###


df_scaled = df_2014

# First, transforming the most highly skewed numerical attributes. We will only worry about these three, because I came from the future and the other skewed variables do not make it to the final model


# Personal Wealth is inverse transformed
skewness(df_scaled$wealth.worth.in.billions)
df_scaled$wealth.worth.in.billions = 1/df_scaled$wealth.worth.in.billions
skewness(df_scaled$wealth.worth.in.billions)

# Percent Wealth since 2001 is negative inverse transformed
skewness(df_scaled$pct.wealth.since.2001)
df_scaled$pct.wealth.since.2001 = (1/(max(df_scaled$pct.wealth.since.2001 + 1) - df_scaled$pct.wealth.since.2001))      
skewness(df_scaled$pct.wealth.since.2001)                                                                               

# Year Company Founded is negative log transformed
skewness(df_scaled$company.founded)
df_scaled$company.founded = log(max(df_scaled$company.founded + 1) - df_scaled$company.founded)
skewness(df_scaled$company.founded)

skewness(df_scaled$location.gdp.2014)
skewness(df_scaled$demographics.age)
skewness(df_scaled$pct.gdp.since.2001)

# Then, scaling

df_scaled = df_scaled %>% mutate(company.founded = scale(company.founded, center=TRUE, scale=TRUE))
df_scaled = df_scaled %>% mutate(demographics.age = scale(demographics.age, center=TRUE, scale=TRUE))
df_scaled = df_scaled %>% mutate(wealth.worth.in.billions = scale(wealth.worth.in.billions, center=TRUE, scale=TRUE))
df_scaled = df_scaled %>% mutate(pct.wealth.since.1996 = scale(pct.wealth.since.1996, center=TRUE, scale=TRUE))
df_scaled = df_scaled %>% mutate(pct.wealth.since.2001 = scale(pct.wealth.since.2001, center=TRUE, scale=TRUE))
df_scaled = df_scaled %>% mutate(location.gdp.2014 = scale(location.gdp.2014, center=TRUE, scale=TRUE))
df_scaled = df_scaled %>% mutate(pct.gdp.since.1996 = scale(pct.gdp.since.1996, center=TRUE, scale=TRUE))
df_scaled = df_scaled %>% mutate(pct.gdp.since.2001 = scale(pct.gdp.since.2001, center=TRUE, scale=TRUE))

summary(df_scaled)




### Preparation of final data-set to be used in model ###


df_final = subset(df_scaled, select = c(company.founded, 
                                        #company.is.founder, 
                                        demographics.age, 
                                        #is.female, 
                                        #wealth.is.inherited,
                                        wealth.worth.in.billions,
                                        #wealth.how.is.financial,
                                        pct.wealth.since.2001,
                                        location.gdp.2014,
                                        pct.gdp.since.2001
                                        ))

summary(df_final)

par(mfrow=c(1,1))
par(mfrow=c(2,3))

for (i in seq(1:length(names(df_final)))) {
  if (is.numeric(df_final[,i])) {
    hist(df_final[,i], main = names(df_final)[i], xlab = "Z-Score")
    print(skewness(df_final[,i]))
  }
}


### Let the clustering begin ###


# K-Means


nc_km = NbClust(data = df_final, min.nc = 2, max.nc = 10, method = 'kmeans')       # 4 clusters

par(mfrow=c(1,1))

km4 = kmeans(df_final, 4)
fviz_cluster(km4, data = df_final, repel = TRUE, show.clust.cent = FALSE)
km4_stats = cluster.stats(dist(df_final),  km4$cluster, silhouette = TRUE)
km4_stats$avg.silwidth

par(mfrow=c(2,3))
for (i in 1:length(names(df_2014))){
  if (names(df_2014)[i] %in% names(df_final)) {
    boxplot(df_2014[[i]] ~ km4$cluster, xlab="cluster", main=paste(names(df_2014)[i], " - K-Means"))
  }
}



# Density-Based
par(mfrow=c(1,1))
kNNdistplot(df_final, k = 5)

abline(h = 1, lty = 2)

dbsc <- dbscan(df_final, eps = 1, minPts = 10)

fviz_cluster(dbsc, data = df_final, stand = F,
             ellipse = T, show.clust.cent = F,
             geom = "point", main = "Cluster Plot - Dimensions 1 and 2")

fviz_cluster(dbsc, data = df_final, stand = F,
             ellipse = T, show.clust.cent = F,
             axes = c(1,6), geom = "point", main = "Cluster Plot - Dimensions 1 and 6")

print(dbsc)

par(mfrow=c(2,3))
for (i in 1:length(names(df_2014))){
  if (names(df_2014)[i] %in% names(df_final)) {
    boxplot(df_2014[[i]] ~ dbsc$cluster, xlab="cluster", main=paste(names(df_2014)[i], " - DBS"))
  }
}

cluster.count = summary(as.factor(dbsc$cluster))
sum(cluster.count[2:3])/sum(cluster.count)


### Time to make some pretty pictures ###

# Make variables to store cluster assignments for easy scripting
clust1_ind = which(dbsc$cluster == 1)
clust2_ind = which(dbsc$cluster == 2)
clust3_ind = which(dbsc$cluster == 3)
clust4_ind = which(dbsc$cluster == 4)
clust5_ind = which(dbsc$cluster == 5)

# Scatterplot of pct.wealth.since.2001 vs. pct.gdp.since 2001 colored by cluster (excludes noise)
p = ggplot(df_2014[which(dbsc$cluster != 0),]) + 
  geom_point(
    aes(
      y = pct.wealth.since.2001,
      x = pct.gdp.since.2001, 
      color = as.factor(dbsc$cluster[which(dbsc$cluster != 0)])),
    alpha = 0.3,
    size = 2
    ) + 
  theme(legend.position = "right") +
  scale_color_brewer(palette = "Set1") + 
  labs(color = "Cluster", subtitle = "Separation by Scatterplot") + 
  ggtitle("Pct. Wealth vs. Pct. GDP since 2001")

p

par(mfrow = c(1,1))
boxplot(df_2014$wealth.worth.in.billions[which(dbsc$cluster != 0)] ~ dbsc$cluster[which(dbsc$cluster != 0)], 
        ylim = c(0, 40),
        xlab = "Cluster",
        ylab = "Wealth in Billions",
        main = "Wealth Inequality Among Billionaires")


# Bar graph: Geographical Region by Cluster
b = ggplot(df_2014) + 
  geom_bar(
    aes(
      x = location.region,
      fill = location.region
    )
  ) + facet_grid(
    cols = vars(dbsc$cluster)
  ) + theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )

b

# Histogram: wealth.worth.in.billions for Clusters 1 and 3
h = ggplot(df_2014[c(clust1_ind, clust3_ind),]) + 
  geom_histogram(
    aes(
      x = wealth.worth.in.billions[c(clust1_ind, clust3_ind)]
    ), color = "black",
    fill = "grey"
  ) + facet_grid(cols = vars(dbsc$cluster[c(clust1_ind, clust3_ind)]))

h

# Histogram: wealth.worth.in.billions for Clusters 2 and 4
h = ggplot(df_2014[c(clust2_ind, clust4_ind),]) + 
  geom_histogram(
    aes(
      x = wealth.worth.in.billions[c(clust2_ind, clust4_ind)]
    ), color = "black",
    fill = "grey"
  ) + facet_grid(cols = vars(dbsc$cluster[c(clust2_ind, clust4_ind)]))

h


# Histogram: pct.wealth.since.2001 for Clusters 1 and 3
h = ggplot(df_2014[c(clust1_ind, clust3_ind),]) + 
  geom_histogram(
    aes(
      x = pct.wealth.since.2001[c(clust1_ind, clust3_ind)]
    ), color = "black",
    fill = "grey"
  ) + facet_grid(cols = vars(dbsc$cluster[c(clust1_ind, clust3_ind)]))

h

# Histogram: pct.wealth.since.2001 for Clusters 2 and 4
h = ggplot(df_2014[c(clust2_ind, clust4_ind),]) + 
  geom_histogram(
    aes(
      x = pct.wealth.since.2001[c(clust2_ind, clust4_ind)]
    ), color = "black",
    fill = "grey"
  ) + facet_grid(cols = vars(dbsc$cluster[c(clust2_ind, clust4_ind)]))

h

# Bar graph: Gender by Cluster
b = ggplot(df_2014) + 
  geom_bar(
    aes(
      x = demographics.gender,
      fill = demographics.gender
    )
  ) + facet_grid(
    cols = vars(dbsc$cluster)
  ) + theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )

b



# Bar graph: is.founder by Cluster
b = ggplot(df_2014) + 
  geom_bar(
    aes(
      x = company.is.founder,
      fill = company.is.founder
    )
  ) + facet_grid(
    cols = vars(dbsc$cluster),
  ) + theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )
b

# Bar graph: wealth.is.inherited by Cluster
b = ggplot(df_2014) + 
  geom_bar(
    aes(
      x = wealth.is.inherited,
      fill = wealth.is.inherited
    )
  ) + facet_grid(
    cols = vars(dbsc$cluster),
  ) + theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )
b

# Bar graph: wealth.how.category by Cluster
b = ggplot(df_2014[which((dbsc$cluster != 0)&!(df_2014$wealth.how.category %in% c('','0'))),]) + 
  geom_bar(
    aes(
      x = wealth.how.category,
      fill = wealth.how.category
    )
  ) + facet_grid(
    cols = vars(dbsc$cluster[which((dbsc$cluster != 0)&!(df_2014$wealth.how.category %in% c('','0')))]),
  ) + theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  ) + 
  ggtitle("wealth.how.category by Cluster")
b

# Bar graph: wealth.how.inherited by Cluster
b = ggplot(df_2014[which(dbsc$cluster != 0),]) + 
  geom_bar(
    aes(
      x = wealth.how.inherited,
      fill = wealth.how.inherited
    )
  ) + facet_grid(
    cols = vars(dbsc$cluster[which(dbsc$cluster != 0)]),
  ) + theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )
b

# Bar graph: wealth.how.industry by Cluster
b = ggplot(df_2014[which(dbsc$cluster != 0),]) + 
  geom_bar(
    aes(
      x = wealth.how.industry,
      fill = wealth.how.industry
    )
  ) + facet_grid(
    cols = vars(dbsc$cluster[which(dbsc$cluster != 0)]),
  ) + theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )
b

# Bar graph: wealth.how.industry by Cluster
b = ggplot(df_2014[which((dbsc$cluster != 0)&(df_2014$wealth.type != '')),]) + 
  geom_bar(
    aes(
      x = wealth.type,
      fill = wealth.type
    )
  ) + facet_grid(
    cols = vars(dbsc$cluster[which((dbsc$cluster != 0)&(df_2014$wealth.type != ''))]),
  ) + theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )
b

five.number.summary = as.data.frame(matrix(ncol = 6))
names(five.number.summary) = names(summary(df_2014$wealth.worth.in.billions))
five.number.summary = five.number.summary[-1,]
five.number.summary

for (i in seq(2:6)) {
  five.number.summary = rbind(five.number.summary, summary(df_2014$wealth.worth.in.billions[which(dbsc$cluster == i)]))
}

names(five.number.summary) = names(summary(df_2014$wealth.worth.in.billions))
five.number.summary






h = ggplot(df_2014[which(df_2014$location.citizenship == "China"),]) + 
  geom_histogram(
    aes(
      x = dbsc$cluster[which(df_2014$location.citizenship == "China")],
      fill = dbsc$cluster[which(df_2014$location.citizenship == "China")]
    )
  )

h




















