#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(wordcloud2)
library(tm)
library("dplyr")
library(tibble)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$wordcloud <- renderWordcloud2({
    end_time = input$interval
    level = (end_time-2)*60*60/2
    tweet_cleaned = read.csv("tweet.csv")
    tweet_sub = tweet_cleaned[1:level,]
    
    tweet_content = toString(tweet_sub$Content)
    
    docs = Corpus(VectorSource(tweet_content)) %>%
      tm_map(removePunctuation) %>%
      tm_map(removeNumbers) %>%
      tm_map(tolower)  %>%
      tm_map(removeWords, stopwords("english")) %>%
      tm_map(stripWhitespace) %>%
      tm_map(PlainTextDocument)
    
    tdm = TermDocumentMatrix(docs) %>%
      as.matrix()
    
    content = as.matrix(tdm[,1])
    content = as.matrix(content[order(content, decreasing=TRUE),])
    
    print("head(Whole Book)")
    print(head(content))
    print("Whole Book's most occuring words:")
    print(head(rownames(content)))
    
    pal <- brewer.pal(9, "YlGnBu")
    pal <- pal[-(1:3)]
    
    
    #wordcloud(rownames(content), content, min.freq =100, scale=c(5, .2), random.order = FALSE, random.color = FALSE, colors= pal)
    
    content2 = data.frame(content)
    content2=rownames_to_column(content2, var = "word")
    
    wordcloud2(content2,size=0.5,minRotation = pi/2, maxRotation = pi/2,color = pal)
  })
  
})
