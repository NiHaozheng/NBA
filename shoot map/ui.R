library(shiny)
library(ggplot2)
library(hexbin)
library(dplyr)
library(httr)
library(jsonlite)

source("helpers.R")
source("plot_court.R")
source("players_data.R")
source("fetch_shots.R")
source("hex_chart.R")
source("scatter_chart.R")
source("heatmap_chart.R")

shinyUI(
  fixedPage(
    theme = "flatly.css",
    title = "Interactive NBA Shot Charts by 4GeDaiBiao",
    titlePanel("Interactive NBA Shot Charts by 4GeDaiBiao"),
    tags$head(
      tags$link(rel = "apple-touch-icon", href = "basketball.png"),
      tags$link(rel = "icon", href = "basketball.png"),
      tags$link(rel = "stylesheet", type = "text/css", href = "shared/selectize/css/selectize.bootstrap3.css"),
      tags$link(rel = "stylesheet", type = "text/css", href = "https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.10.0/css/bootstrap-select.min.css"),
      tags$link(rel = "stylesheet", type = "text/css", href = "custom_styles.css"),
      tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.min.js"),
      tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.10.0/js/bootstrap-select.min.js"),
      tags$script(src = "shared/selectize/js/selectize.min.js"),
      includeScript("www/google-analytics.js")
    ),
    fluidRow(
      column(6,
             selectInput("team",
                         "Select a Team:",
                         choices=c("Enter a team..." = "",team),
                         selected = "Rockets")),
      
      column(6,
             selectInput("player_name",
                         "Select a Player:",
                         choices = c("Enter a player..." = "", 
                                     available_players[available_players$team_name=='Rockets',]$name),
                         selected = default_player$name))),
    
    fixedRow(class = "primary-content",
             
     div(class = "col-sm-5 col-md-9",
         div(class = "player info",
             uiOutput("player_photo"),
             
             selectInput(inputId = "season",
                         label = "Season",
                         choices = rev(default_seasons),
                         selected = default_season,
                         selectize = FALSE),
             selectInput(inputId = "minutes",
                         label = "Minutes Remaining",
                         choices = c(1:5),
                         selected = 5,
                         selectize = FALSE),
             h3(textOutput("summary_stats_header")),
             uiOutput("summary_stats")
             ))   , 
      div(class = "col-sm-7 col-md-9",
          plotOutput("court", height = "auto"),
          
        div(class = "col-sm-1 col-md-9"),
          div(class='col-sm-3 col-md-9',
              radioButtons(inputId = "chart_type",
                           label = "Chart Type",
                           choices = c( "Scatter", "Heat Map","Hexagonal"),
                           selected = "Scatter")
            ),
        div(class='col-sm-4 col-md-9',
          selectInput(inputId = "shot_zone_angle_filter",
                      label = "Shot Angles",
                      choices = c("Left Side" = "Left Side(L)",
                                  "Left Center" = "Left Side Center(LC)",
                                  "Center" = "Center(C)",
                                  "Right Center" = "Right Side Center(RC)",
                                  "Right Side" = "Right Side(R)"),
                      multiple = TRUE,
                      selectize = FALSE)
          )
      ,
      div(class='col-sm-4 col-md-9',  
          selectInput(inputId = "shot_distance_filter",
                      label = "Shot Distances",
                      choices = c("0-8 ft" = "Less Than 8 ft.",
                                  "8-16 ft" = "8-16 ft.",
                                  "16-24 ft" = "16-24 ft.",
                                  "24+ ft" = "24+ ft."),
                      multiple = TRUE,
                      selectize = FALSE)
          ),
      div(class='col-sm-3 col-md-9',  
      selectInput(inputId = "shot_result_filter",
                  label = "FG Made/Missed",
                  choices = c("All" = "all", "Made" = "made", "Missed" = "missed"),
                  selected = "all",
                  selectize = FALSE)
      ),
      div(class='col-sm-5 col-md-9',
          uiOutput("hex_metric_buttons"),
          uiOutput("hexbinwidth_slider"),
          uiOutput("hex_radius_slider")
      )  
      
      )
  ))
)
