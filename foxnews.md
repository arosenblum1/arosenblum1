# Performing NLP on Fox News Newsletters

*The code for this project was written in R. LDA and PCA functions were taken from the MASS and psych packages, respectively. I wasn’t yet used to using the tidyverse stack at the time of this analysis, so all manipulation and visualization was done in base R. I contributed the portion of the report titled “Linear Discriminant Analysis”, pages 7 - 9 in the technical report; my contribution is detailed more fully on pages 11 - 12.*

[[Full Technical Report](https://arosenblum1.github.io/arosenblum1/Portfolio/Performing%20NLP%20on%20Fox%20News%20Newsletters/Report%20-%20Fox%20News.pdf)]

## Summary of My Contribution
#### Opportunity
In recent years, the messaging put forth by FOX News has come under quite a bit of scrutiny for its divisive
rhetoric and apparent disdain for mainstream science. The COVID-19 pandemic seemed to exacerbate
these factors, with much of their primetime programming being spent discrediting government health
officials and their advice and research confirming that people who live in geographical areas where FOX
News has high viewership were less likely to adhere to social distancing guidelines. Using a corpus of
newsletters collected from several FOX News outlets both before and after the onset of the pandemic, we
sought to apply Natural Language Processing (NLP) techniques to quantify and analyze the rhetoric
produced by FOX News, and characterize the change in messaging exhibited after the onset of the COVID19 pandemic.
#### Methodology
The NLP technique Term Frequency/Inverse Document Frequency (TF-IDF) was first used to quantify the
importance of every word in each newsletter. Then the dimensionality reduction technique Principle
Component Analysis (PCA) was used to group words that often appeared together into composite variables
representing a larger subject consisting of many terms. For example, “science”, “study”, and “nasa” among
other terms were grouped together and labeled as simply “Science” – other major subjects identified include
Personal Health and US Politics. VADER Sentiment Analysis, another NLP technique, was used to
measure Positivity, Negativity, and Neutrality strength of each document. Finally, the classification algorithm
Linear Discriminant Analysis (LDA) was applied to characterize the difference messaging trends around
these subjects before and after the start of the pandemic.
#### Conclusions
Initially, I was surprised to learn that there was no
significant change in sentiment trends (that is, Positivity
and Negativity) in newsletters concerning Science after
the pandemic began. However after drilling down, the
reason for this became evident: in pandemic-era
newsletters, Science-focused emails were far more
scarce than they had been pre-COVID. Conversely, the
subject of Personal Health (which contains words like
“lifestyle” and “treat”) became much more prominent
during the pandemic. On its own, this increase is
understandable – with everyone trying to stay safe from COVID, a higher amount of content focused on
health advice makes sense. However, when coupled with the decrease in Science, this change indicates
that the content labeled Personal Health contains health advice not based in scientific findings. While there
are a select few documents in either era were identified as having moderately high scores in both Science
and Personal Health (identified in the plot above as “Joint Coverage”), the division between these two
subjects is stark. At a time when science literacy is critically important, this trend has the potential to be
quite problematic.
#### Recommendations
To account for this lack of science-informed health advice, trust in science must be regained where
possible. A campaign of public education into what “Science” actually means (it’s a process, not just a
bunch of facts!) aimed at an all-ages audience in geographic areas with large FOX News audiences could
restore trust in science, and the processes necessary to reach scientific conclusions. This campaign should
include inexpensive, interactive experiments where results defy the common-sense expectations and are
obvious to the eye. A common example is predicting how many drops of water a can penny hold – invariably,
the answer is much higher than expected due to the unseen interactions of surface tension.
The purpose of these proposed demonstrations is to illustrate that science is a process, and medical advice
should always be based on the findings of those who go through the process of science rather than
“common sense”. Ideally, these demonstrations should be done live, in-person, at a public venue (parks,
rec centers, street fests, etc.) and led by a charismatic individual who is either a member of the local
community or is at least seen to conform to local culture.
