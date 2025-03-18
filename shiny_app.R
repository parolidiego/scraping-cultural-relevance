
library(shiny)
library(dplyr)
library(ggplot2)
library(shinythemes)
library(shinyjs)

options(scipen = 999) # We remove the scientific notation

ny <- read_csv("data/nyt_database.csv")
movies <-  read_csv("data/box_office_database.csv")
guardian <- read_csv("data/guardian_database.csv")
bill <- read_csv("data/billboard_database.csv")

data <-  movies |> 
  full_join(bill2, by = "date") |> 
  full_join(ny, by = "date") |> 
  full_join(guardian, by = "date")

data <- data %>% # This is for cleaning the columns that where in HTML format
  mutate(across(everything(), ~ str_replace_all(.x, "<.+?>", ""))) %>%
  mutate(across(everything(), ~ if_else(.x == "NA", NA, .x)))



# Interface


ui <- fluidPage(
  useShinyjs(),
  theme = shinytheme("flatly"),
  tags$head( # We create different styles for the titles
    tags$style(HTML(".news-section { margin-bottom: 30px; } .bold-title { font-weight: bold; font-size: 24px; } .center-content { text-align: center; } .image-box { display: flex; justify-content: center; } .large-title { font-size: 28px; font-weight: bold; } .info-box { margin-top: 20px; padding: 10px; border: 1px solid #ddd; border-radius: 8px; background-color: #f9f9f9; } .extra-large-title { font-size: 32px; font-weight: bold; text-align: center; }"))
  ),
  titlePanel("Movie, Song and News of the Day"),
  sidebarLayout(
    sidebarPanel(
      dateInput("date", "Choose a date:", value = Sys.Date(), format = "yyyy-mm-dd", startview = "month", weekstart = 1)
    ),
    # We set the structure of the page by creating different tabs
    mainPanel(
      tabsetPanel(
        tabPanel("Movie",
                 h3("Most Successful Movie", class = "bold-title center-content"),
                 div(class = "image-box", uiOutput("image")),
                 div(class = "large-title center-content", textOutput("best_selling")),
                 div(class = "info-box",
                     h4("Distributor", class = "bold-title"),
                     textOutput("distributor"),
                     h4("Genres", class = "bold-title"),
                     textOutput("genres"),
                     h4("Running Time", class = "bold-title"),
                     textOutput("running_time"),
                     h4("Daily Earnings", class = "bold-title"),
                     textOutput("daily_earnings"),
                     h4("Worldwide Earnings", class = "bold-title"),
                     textOutput("world_wide_earnings"),
                     h4("Description", class = "bold-title"),
                     textOutput("description")
                 )
        ),
        tabPanel("Song",
                 h3("Number 1 Song on Billboard", class = "bold-title center-content"),
                 div(class = "image-box", uiOutput("image_url")),
                 div(class = "large-title center-content", textOutput("song")),
                 h4("Artist", class = "bold-title center-content"),
                 div(class = "large-title center-content", textOutput("artist")),
                 div(class = "info-box",
                     h4("Weeks on Chart", class = "bold-title"),
                     textOutput("weeks_on_chart"),
                     h4("Weeks at #1", class = "bold-title"),
                     textOutput("weeks_at_1"),
                     h4("Last Week", class = "bold-title"),
                     textOutput("last_week")
                 )
        ),
        tabPanel("News",
                 h2("Headlines of the Day", class = "extra-large-title"),
                 h3("The Guardian", class = "bold-title center-content"),
                 div(class = "news-section",
                     div(class = "large-title", uiOutput("news_link")),
                     textOutput("subtitle")
                 ),
                 h3("New York Times", class = "bold-title center-content"),
                 div(class = "news-section",
                     div(class = "large-title", textOutput("headline")),
                     textOutput("lead_paragraph")
                 )
        )
      )
    )
  )
)



# Server logic
server <- function(input, output, session) {
  
  # We create a data frame that interacts with the date given
  filtered_data <- reactive({
    data %>% filter(date == input$date)
  })
  
  # We extract the information that we need from the previous dataset
  output$best_selling <- renderText({
    movie <- filtered_data()
    if (nrow(movie) > 0) return(movie$best_selling) else return("No data available")
  })
  
  output$image <- renderUI({
    movie <- filtered_data()
    if (nrow(movie) > 0) {
      img(src = movie$image, height = "300px", class = "img-responsive")
    }
  })
  
  output$distributor <- renderText({
    movie <- filtered_data()
    if (nrow(movie) > 0) return(movie$distributor) else return("No data available")
  })
  
  output$genres <- renderText({
    movie <- filtered_data()
    if (nrow(movie) > 0) return(movie$genres) else return("No data available")
  })
  
  output$running_time <- renderText({
    movie <- filtered_data()
    if (nrow(movie) > 0) return(movie$running_time) else return("No data available")
  })
  
  output$world_wide_earnings <- renderText({
    movie <- filtered_data()
    if (nrow(movie) > 0) return(paste("$", format(movie$worldwide_earnings, big.mark = ","))) else return("No data available")
  })
  
  output$daily_earnings <- renderText({
    movie <- filtered_data()
    if (nrow(movie) > 0) return(paste("$", format(movie$daily_earnings, big.mark = ","))) else return("No data available")
  })
  
  output$description <- renderText({
    movie <- filtered_data()
    if (nrow(movie) > 0) return(movie$description) else return("No data available")
  })
  
  output$song <- renderText({
    song <- filtered_data()
    if (nrow(song) > 0) return(song$song) else return("No data available")
  })
  
  output$artist <- renderText({
    song <- filtered_data()
    if (nrow(song) > 0) return(song$artist) else return("No data available")
  })
  
  output$last_week <- renderText({
    song <- filtered_data()
    if (nrow(song) > 0) return(song$last_week) else return("No data available")
  })
  
  output$image_url <- renderUI({
    song <- filtered_data()
    if (nrow(song) > 0) {
      img(src = song$image_url, height = "300px", class = "img-responsive")
    }
  })
  
  output$weeks_on_chart <- renderText({
    song <- filtered_data()
    if (nrow(song) > 0) return(song$weeks_on_chart) else return("No data available")
  })
  
  output$weeks_at_1 <- renderText({
    song <- filtered_data()
    if (nrow(song) > 0) return(song$weeks_at_1) else return("No data available")
  })
  
  # We add an attribute to this headline to include the url of the newsspaper
  output$news_link <- renderUI({
    headlines <- filtered_data()
    if (nrow(headlines) > 0) { if (is.na(headlines$title)) return("No data availabe") else
      tags$a(href = headlines$url, target = "_blank", class = "large-title", headlines$title)
    } else return("No data available")
  })
  
  output$subtitle <- renderText({
    headlines <- filtered_data()
    if (nrow(headlines) > 0) if (is.na(headlines$subtitle)) return("") else return(headlines$subtitle)
  })
  
  output$headline <- renderText({
    headlines <- filtered_data()
    if (nrow(headlines) > 0){if (is.na(headlines$headline)) return("No data available") else return(headlines$headline)} else return("No data available")
  })
  
  output$lead_paragraph <- renderText({
    headlines <- filtered_data()
    if (nrow(headlines) > 0) if (is.na(headlines$lead_paragraph)) return("") else return(headlines$lead_paragraph)
  })
  
}

# We execute application
shinyApp(ui = ui, server = server)
