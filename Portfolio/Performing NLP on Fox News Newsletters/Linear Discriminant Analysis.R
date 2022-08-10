# This code takes 1 hour 9 minutes to run (on my desktop, at least)

start.time.global = Sys.time()
start.time.global
############################################################################################
# Load Files and subset accordingly

start.time = Sys.time()
start.time
lem.tfidf.orig = read.csv('Cleaned Up Fox Dataset, Tfidf Lemmatizer, New HTML removal.csv')
Sys.time() - start.time

names(lem.tfidf.orig)[1:100]

lem.tfidf = subset(lem.tfidf.orig, select = -c(9:66))
names(lem.tfidf)[1:100]

lem.count.orig = read.csv('Cleaned Up Fox Dataset, Count Lemmatizer, New HTML removal.csv')
names(lem.count.orig)[1:100]

lem.count = subset(lem.count.orig, select = -c(9:66))
names(lem.count)[1:100]


########################################################################################
# Make Word Counter

names(lem.count)[5931:5936]

lem.wordcount.meta = data.frame('Word' = 'test', 'Total Count' = 0, 'Pre-COVID Count' = 0, 'During COVID Count' = 0, stringsAsFactors = F)
lem.wordcount.meta = lem.wordcount.meta[-1,]

which(names(lem.count) == 'COVID.Status')



start.time = Sys.time()
start.time
for(i in 9:5936){                   # Loop term by term, then row by row, to get total word counts sorted by COVID.Status
  print(i)                          # I apologize for doing this so inefficiently, definitely could have subset the data first and sped this up quite a bit
  word = names(lem.count)[i]
  pre.covid.count = 0
  during.covid.count = 0
  for(j in 1:nrow(lem.count)){
    if(lem.count[j,i] == 0){
    } else {
      if(lem.count[j, 5941] == 'Pre-COVID'){
        pre.covid.count = pre.covid.count + lem.count[j,i]
      } else if(lem.count[j, 5941] == 'During COVID') {
        during.covid.count = during.covid.count + lem.count[j,i]
      }
    }
  }
  total.count = pre.covid.count + during.covid.count
  new.row = data.frame('Word' = word, 'Total Count' = total.count, 'Pre-COVID Count' = pre.covid.count, 
                       'During COVID Count' = during.covid.count)
  lem.wordcount.meta = rbind(lem.wordcount.meta, new.row)
}
end.time = Sys.time()
end.time - start.time

lem.wordcount.meta$Pct.Pre.COVID = round((lem.wordcount.meta$Pre.COVID.Count / lem.wordcount.meta$Total.Count) * 100, 2)

write.csv(lem.wordcount.meta, file='Lemmatized Word Counts by COVID.Status - 11-12-20')

#####################################################################################################
# Remove words that occur too many times on either side of the COVID threshold

words.to.remove = subset(lem.wordcount.meta, subset = Pct.Pre.COVID < 15 | Pct.Pre.COVID > 85)
words.to.remove.indices = c()

for(word in words.to.remove$Word){
  words.to.remove.indices = rbind(words.to.remove.indices, which(names(lem.tfidf) == word))
}

lem.tfidf = subset(lem.tfidf, select = -words.to.remove.indices)

################################################################
# Run first PCA

library(psych)

p = prcomp(lem.tfidf[,-c(1:8, which(names(lem.tfidf) == 'VADER.Negativity'):which(names(lem.tfidf) == 'COVID.Status'))])

p

names(lem.tfidf[5937:5941])


head(p$x[,1:10])
rot = p$rotation[,1:20]
names(rot)
class(rot)

head(rot[order(-rot[,1]),1:10])
plot(p)



pcs = p$x[,1:10]

summary(pcs)

##################################################################
# Run PCA with limited PCs and VARIMAX rotation

names(lem.tfidf)[4794:which(names(lem.tfidf) == 'COVID.Status')]

start.time = Sys.time()
start.time
p2 = principal(lem.tfidf[,-c(1:8, 4794:which(names(lem.tfidf) == 'COVID.Status'))],
               nfactors = 20, rotate = 'varimax')
end.time = Sys.time()
pca.time = end.time - start.time
pca.time

##################################################################################
# Explore PCs

loadings = p2$loadings
loadings

head(loadings[order(-loadings[,1]),1:2],30)   # RC1 is not meaningful
head(loadings[order(-loadings[,2]),1:2],30)   # RC3 is not meaningful
head(loadings[order(-loadings[,3]),3:4],30)   # RC4 is science
head(loadings[order(-loadings[,4]),3:4],30)   # RC5 is very political, seemingly about the interactions between politicians in the media
head(loadings[order(-loadings[,5]),5:6],30)   # RC9 is focused on personal life
head(loadings[order(-loadings[,6]),5:6],30)   # RC13 is another political one, about impeachment but focused on congress
head(loadings[order(-loadings[,7]),7:8],30)   # RC12 is about violence, police, and protests
head(loadings[order(-loadings[,8]),7:8],30)   # RC6 is economy and stock market
head(loadings[order(-loadings[,9]),9:10],30)  # RC8 seems to be heavy on the investigations surrounding impeachment
head(loadings[order(-loadings[,10]),9:10],30) # RC2 is about the democratic primary
head(loadings[order(-loadings[,11]),11:12],30) # RC7 seems to involve tech companies and also some fox news personalities. May include some HTML, so probably best to consider this as meaningless
head(loadings[order(-loadings[,12]),11:12],30) # RC10 is focused on nature
head(loadings[order(-loadings[,13]),13:14],30) # RC11 handles natural disasters and extreme weather
head(loadings[order(-loadings[,14]),13:14],30) # RC15 includes some vague political references
head(loadings[order(-loadings[,15]),15:16],30) # RC17 is uninterpretable
head(loadings[order(-loadings[,16]),15:16],30) # RC18 is world leaders with a focus on the British royal family
head(loadings[order(-loadings[,17]),17:18],30) # RC14 exists, I guess
head(loadings[order(-loadings[,18]),17:18],30) # RC16 has a focus on space

head(loadings[order(loadings[,19]),19:20],30)  # RC19 is dichotomous between SCOTUS and Catholicism
head(loadings[order(-loadings[,19]),19:20],30)

head(loadings[order(-loadings[,20]),19:20],30) # RC20 also exists

##################################################################################
# Make dataset for LDA

p2$scores[1:50, 1:10]
names(lem.tfidf[4798])
head(lem.tfidf[,4798])
class(p2$scores)

ds = cbind(as.data.frame(p2$scores), lem.tfidf[,4794:4798])
names(ds)[3:20] = c('Science', 
                    'US.Politics.in.Media',
                    'Personal.Health',
                    'Congress.Surrounding.Impeachment.Hearings',
                    'Police.Violence.and.Protests',
                    'Economy.and.Stock.Market',
                    'Impeachment.Investigations',
                    'Democratic.Primary',
                    'Tech.Companies',
                    'Nature',
                    'Natural.Disasters.and.Extreme.Weather',
                    'RC15',
                    'RC17',
                    'British.Royal.Family',
                    'RC14',
                    'Space.Exploration',
                    'Supreme.Court.vs.Catholicism',
                    'RC20')
class(ds)
head(ds)
str(ds)
summary(ds)

##################################################################################
# Run LDA

library(MASS)

lda = lda(COVID.Status ~ . - RC1 - RC3 - RC15 - RC17 - RC14 - RC20 - VADER.Compound, data = ds)       # Best one
summary(lda)
print(lda)

##################################################################################
# Check classification ability of LDA model

pred = predict(lda)

conf = table(ds$COVID.Status, pred$class)
conf

correct = conf[1,1] + conf[2,2]
incorrect = conf[1,2] + conf[2,1]

correct.pct = round((correct / (correct + incorrect))*100, 2)
correct.pct

##################################################################################
# Explore relationships of high separation PCs with scatter plots

plot(ds$Science, ds$Personal.Health, col=ds$COVID.Status, pch=16,
     xlab = 'Science',
     ylab = 'Personal Health',
     main = 'Personal Health vs. Science',
     cex.main=1.8)
legend(x=80, y=80, legend=c('Pre-COVID', 'During-COVID'), col=c('red', 'black'), pch=16, cex=1.3)

plot(ds$US.Politics.in.Media, ds$Personal.Health, col=ds$COVID.Status, pch=16,
     xlab = 'US Politics in Media',
     ylab = 'Personal Health',
     main = 'Personal Health vs. US Politics in Media',
     cex.main=1.8)
legend(x=80, y=80, legend=c('Pre-COVID', 'During-COVID'), col=c('red', 'black'), pch=16, cex=1.3)

plot(ds$Supreme.Court.vs.Catholicism, ds$Personal.Health, col=ds$COVID.Status, pch=16,
     xlab = 'Supreme Court (positive) vs. Catholicism (negative)',
     ylab = 'Personal Health',
     main = 'Separation by Principal Factors')
legend(x=20, y=80, legend=c('Pre-COVID', 'During-COVID'), col=c('red', 'black'), pch=16)

##################################################################################

end.time.global = Sys.time()
full.run.time = end.time.global - start.time.global
full.run.time  # 1 hr 9 min




























