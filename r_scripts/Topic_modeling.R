library(tm)
library(dplyr)
library(topicmodels)
library(NLP)
library(ggplot2)
library(tidytext)


file.choose()

tweets<-read.csv("C:\\Users\\Win10\\Documents\\Análsis de sentimientos vacunas cubanas\\Dataset\\tweets.csv")

corpus_tweets<-Corpus(VectorSource(tweets))

corpus<-tm_map(corpus_tweets, stripWhitespace)
dtm<-DocumentTermMatrix(corpus)
dtm.mx<-as.matrix(dtm)

k<-5

lda_tweets<-LDA(dtm,k, method = "Gibbs", control = list(iter = 500, seed = 1,
                                                        verbose = 25) )
terms(lda_tweets, 5)

ap_topics <-tidy(lda_tweets, matrix = "beta")
ap_topics

terms_topic <-ap_topics %>% 
  group_by(topic) %>%
  slice_max(beta, n = 5) %>%
  ungroup() %>%
  arrange(topic, -beta)

terms_topic %>% 
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap( ~ topic, scales = "free") +
  scale_y_reordered()
