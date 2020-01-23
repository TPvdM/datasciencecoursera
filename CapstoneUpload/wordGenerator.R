#Downloading data
rm(list=ls())
require(tidyverse)
require(knitr)

url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
download.file(url, destfile = "Dataset.zip", method = "curl")
unzip("Dataset.zip")
unlink(url)

#Loading the English datafiles: Twitter, News, and Blogs
twitter <- readLines("./final/en_Us/en_US.twitter.txt", encoding = "UTF-8", skipNul = T)
news <- readLines("./final/en_Us/en_US.news.txt", encoding = "UTF-8", skipNul = T)
blogs <- readLines("./final/en_Us/en_US.blogs.txt", encoding = "UTF-8", skipNul = T)

#Pulling  a random sample from the data
set.seed(1234)
subTwitter <- twitter[sample(length(twitter) * 0.02)]
subNews <- news[sample(length(news) * 0.02)]
subBlogs <- blogs[sample(length(blogs) * 0.02)]
subTot <- c(subTwitter, subNews, subBlogs)

#Tidying and cleaning the data
require(tm)
require(SnowballC)

subTot1 <- VCorpus(VectorSource(subTot))
rm_apos <- content_transformer(function(x, from, to) gsub(from, to, x))

subTot1 <- subTot1 %>% 
    tm_map(rm_apos, "won't", "will not") %>% 
    tm_map(rm_apos, "can't", "can not") %>% 
    tm_map(rm_apos, "'ve", " have") %>% 
    tm_map(rm_apos, "'m", " am") %>% 
    tm_map(rm_apos, "'s", "") %>% 
    tm_map(rm_apos, "n't", " not") %>% 
    tm_map(rm_apos, "'ll", " will") %>% 
    tm_map(rm_apos, "'re", " are")

toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))

subTot2 <- tm_map(subTot1, toSpace, "(f|ht)tp(s?)://(subTot1*)[subTot1][a-z]+")  
subTot2 <- tm_map(subTot1, toSpace, "@[^\\s]+")
subTot2 <- tm_map(subTot1, tolower)  
subTot2 <- tm_map(subTot1, removeWords, stopwords('english'))  
subTot2 <- tm_map(subTot1, removePunctuation)  
subTot2 <- tm_map(subTot1, removeNumbers)  
subTot2 <- tm_map(subTot1, stripWhitespace)  
subTot2 <- tm_map(subTot1, PlainTextDocument)  

rm(subTot, subTot1, rm_apos, toSpace)

#Creating n-grams
Sys.setenv(JAVA_HOME='C:/Program Files/Java/jre1.8.0_231')
require(rJava)
require(RWeka)

UnigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
uniRaw <- removeSparseTerms(DocumentTermMatrix(subTot2, 
                                               control = list(tokenize = UnigramTokenizer)), 0.9995)

BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
biRaw <- removeSparseTerms(DocumentTermMatrix(subTot2, 
                                              control = list(tokenize = BigramTokenizer)), 0.9995)

TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
triRaw <- removeSparseTerms(DocumentTermMatrix(subTot2, 
                                               control = list(tokenize = TrigramTokenizer)), 0.9995)

QuadgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
quadRaw <- removeSparseTerms(DocumentTermMatrix(subTot2, 
                                               control = list(tokenize = QuadgramTokenizer)), 0.9995)

uniFreq <- sort(colSums(as.matrix(uniRaw)), decreasing=TRUE)
uniWordFreq <- tibble(word=names(uniFreq), freq=uniFreq)
# "the" is the most common word

biFreq <- sort(colSums(as.matrix(biRaw)), decreasing=TRUE)
bigram <- tibble(word=names(biFreq), freq=biFreq)
bigram$word <- as.character(bigram$word)
bigram_split <- strsplit(as.character(bigram$word),split=" ")
bigram <- transform(bigram,first = sapply(bigram_split,"[[",1),second = sapply(bigram_split,"[[",2))
bigram <- data.frame(unigram = as.character(bigram$first), bigram = as.character(bigram$second), freq = bigram$freq,stringsAsFactors=FALSE)
saveRDS(bigram, "./NextWordPredictor/data/bigram.RData")

triFreq <- sort(colSums(as.matrix(triRaw)), decreasing=TRUE)
trigram <- tibble(word=names(triFreq), freq=triFreq)
trigram$word <- as.character(trigram$word)
trigram_split <- strsplit(as.character(trigram$word),split=" ")
trigram <- transform(trigram,first = sapply(trigram_split,"[[",1),second = sapply(trigram_split,"[[",2),third = sapply(trigram_split,"[[",3))
trigram <- data.frame(unigram = as.character(trigram$first), bigram = as.character(trigram$second), trigram = as.character(trigram$third), freq = trigram$freq,stringsAsFactors=FALSE)
saveRDS(trigram, "./NextWordPredictor/data/trigram.RData")

quadFreq <- sort(colSums(as.matrix(quadRaw)), decreasing=TRUE)
quadgram <- tibble(word=names(quadFreq), freq=quadFreq)
quadgram$word <- as.character(quadgram$word)
quadgram_split <- strsplit(as.character(quadgram$word),split=" ")
quadgram <- transform(quadgram,first = sapply(quadgram_split,"[[",1),second = sapply(quadgram_split,"[[",2),third = sapply(quadgram_split,"[[",3), fourth = sapply(quadgram_split,"[[",4))
quadgram <- data.frame(unigram = as.character(quadgram$first), bigram = as.character(quadgram$second), trigram = as.character(quadgram$third), quadgram = as.character(quadgram$fourth), freq = quadgram$freq,stringsAsFactors=FALSE)
saveRDS(quadgram, "./NextWordPredictor/data/quadgram.RData")

out <- list("n2" = bigram, "n3" = trigram, "n4" = quadgram)
saveRDS(out, file = "words.RData")


