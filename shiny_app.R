
library(shiny)
library(dplyr)
library(ggplot2)
library(shinythemes)
library(shinyjs)


ny <- read_csv("data/nyt_database.csv")
movies <-  read_csv("data/box_office_database.csv")
guardian <- read_csv("data/guardian_database.csv")
bill <- read_csv("data/billboard_database.csv")

data <-  movies |> 
  full_join(bill2, by = "date") |> 
  full_join(ny, by = "date") |> 
  full_join(guardian, by = "date")

data <- data %>%
  mutate(across(everything(), ~ str_replace_all(.x, "<.+?>", "")))




# Interfaz de usuario mejorada
ui <- fluidPage(
  useShinyjs(),
  theme = shinytheme("flatly"),
  tags$head(
    tags$style(HTML(".news-section { margin-bottom: 30px; } .bold-title { font-weight: bold; }"))
  ),
  titlePanel("Movie, Song and News of the Day"),
  sidebarLayout(
    sidebarPanel(
      dateInput("date", "Choose a date:", value = Sys.Date(), format = "yyyy-mm-dd", startview = "month", weekstart = 1)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Overview",
                 div(id = "content",
                     fluidRow(
                       column(6,
                              h3("Most Successful Movie", class = "bold-title"),
                              strong(textOutput("best_selling")),
                              uiOutput("image")
                       ),
                       column(6,
                              h3("Number 1 Song on Billboard", class = "bold-title"),
                              strong(textOutput("song_artist")),
                              uiOutput("image_url")
                       )
                     ),
                     hr(),
                     h3("Headlines of the Day", class = "bold-title"),
                     div(class = "news-section",
                         strong(uiOutput("news_link")),
                         textOutput("subtitle")
                     ),
                     div(class = "news-section",
                         strong(textOutput("headline")),
                         textOutput("abstract")
                     )
                 )
        ),
        tabPanel("Movie Information",
                 h3("Movie Earnings", class = "bold-title"),
                 textOutput("daily_earnings"),
                 h3("Movie Description", class = "bold-title"),
                 textOutput("description")
        )
      )
    )
  )
)

# Lógica del servidor
server <- function(input, output, session) {
  
  filtered_data <- reactive({
    data %>% filter(date == input$date)
  })
  
  output$best_selling <- renderText({
    best_selling <- filtered_data()
    if (nrow(best_selling) > 0) return(best_selling$best_selling) else return("There is no data for this day")
  })
  
  output$image <- renderUI({
    best_selling <- filtered_data()
    if (nrow(best_selling) > 0) {
      img(src = best_selling$image, height = "300px", class = "img-responsive")
    }
  })
  
  output$song_artist <- renderText({
    song <- filtered_data()
    if (nrow(song) > 0) return(paste(song$song, "-", song$artist)) else return("There is no data for this day")
  })
  
  output$image_url <- renderUI({
    song <- filtered_data()
    if (nrow(song) > 0) {
      img(src = song$image_url, height = "300px", class = "img-responsive")
    }
  })
  
  output$news_link <- renderUI({
    news <- filtered_data()
    if (nrow(news) > 0) {
      tags$a(href = news$url, target = "_blank", news$title)
    }
  })
  
  output$subtitle <- renderText({
    headlines <- filtered_data()
    if (nrow(headlines) > 0) return(headlines$subtitle) else return("")
  })
  
  output$headline <- renderText({
    headlines <- filtered_data()
    if (nrow(headlines) > 0) return(headlines$headline) else return("")
  })
  
  output$abstract <- renderText({
    headlines <- filtered_data()
    if (nrow(headlines) > 0) return(headlines$abstract) else return("")
  })
  
  output$daily_earnings <- renderText({
    movie <- filtered_data()
    if (nrow(movie) > 0) return(paste("$", format(movie$daily_earnings, big.mark = ","))) else return("No earnings data available")
  })
  
  output$description <- renderText({
    movie <- filtered_data()
    if (nrow(movie) > 0) return(movie$description) else return("No description available")
  })
  
  observeEvent(input$date, {
    runjs("document.getElementById('content').scrollIntoView({ behavior: 'smooth' });")
  })
}

# Execut application

shinyApp(ui = ui, server = server)
