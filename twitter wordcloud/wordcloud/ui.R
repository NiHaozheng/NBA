#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(wordcloud2)
library(tm)
library(dplyr)
library(wordcloud)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Word Cloud of Tweets"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("team", "Choose a Team:",
                  list(`East` = c("Celtics","Nets"),
                       `West` = c("Spurs","Warriors"))
      ),
       sliderInput("interval",
                   "Select Time Period:",
                   min =2,
                   max =6,
                   step = 0.5,
                   value = 4)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      wordcloud2Output("wordcloud")
    )
  )
))
