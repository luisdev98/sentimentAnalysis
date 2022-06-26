library(NLP)
library(syuzhet)
library(tm)
library(RColorBrewer)
library(tokenizers)
library(wordcloud)

file.choose()

tweets=read.csv("C:\\Users\\Win10\\Documents\\Análsis de sentimientos vacunas cubanas\\Dataset\\tweets.csv") 

tweets<-get_tokens(tweets)
View(tweets)
length(tweets)
head(tweets)
sentimientos_df<-get_nrc_sentiment(tweets, language = "spanish")

head(sentimientos_df)
View(sentimientos_df)

summary(sentimientos_df)


terms_fear <- tweets [sentimientos_df$fear > 0]
terms_fear_frec <- sort(table(unlist(terms_fear)), decreasing = TRUE)
head(terms_fear_frec)

terms_trust <- tweets [sentimientos_df$trust > 0]
terms_trust_frec <- sort(table(unlist(terms_trust)), decreasing = TRUE)
head(terms_trust_frec)


terms_sadness <- tweets [sentimientos_df$sadness > 0]
terms_sadness_frec <- sort(table(unlist(terms_sadness)), decreasing = TRUE)
head(terms_sadness_frec)

terms_negative <- tweets [sentimientos_df$negative > 0]
terms_negative_frec <- sort(table(unlist(terms_negative)), decreasing = TRUE)
head(terms_negative_frec)

terms_positive <- tweets [sentimientos_df$positive > 0]
terms_positive_frec <- sort(table(unlist(terms_positive)), decreasing = TRUE)
head(terms_positive_frec)




wc_vector <- c(paste(tweets[sentimientos_df$fear > 0], collapse = " "), 
               paste(tweets[sentimientos_df$sadness > 0], collapse = " "),
               paste(tweets[sentimientos_df$trust > 0], collapse =  " "),
               paste(tweets[sentimientos_df$negative > 0], collapse = " "),
               paste(tweets[sentimientos_df$positive > 0], collapse = " "))


wc_corpus <- Corpus(VectorSource(wc_vector))
wc_tdm <- TermDocumentMatrix(wc_corpus)
wc_tdm <- as.matrix(wc_tdm)

#wc_tdm <-wc_tdm %>% rowsum() %>% sort(decreasing = TRUE)
#wc_tdm <-data.frame(palabras = names(wc_tdm), frec = wc_tdm)

warnings()
#wc_tdm [1:20]

colnames(wc_tdm) <- c('Miedo', 'Tristeza','Confianza', 'Negativo','Positivo')
View(wc_tdm)

set.seed(100)
comparison.cloud(wc_tdm, random.order = FALSE, colors = c('blue', 'gray', 'green',
                                                          'red', 'orange'), 
                 title.size = 0.5 ,max.words = 70, scale = c(1, 1), rot.per = 0.1)


barplot(colSums(prop.table(wc_tdm)), horiz = F, las = 1,
        cex.names = 0.5, col = brewer.pal(n = 10, name = "Set3"), xlab = "Palabras de polaridad positiva",
        ylab = NULL)

sentimientos_valencia <-(sentimientos_df$negative *-1) + sentimientos_df$positive

simple_plot(sentimientos_valencia)

