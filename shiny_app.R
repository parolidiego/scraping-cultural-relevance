
library(shiny)
library(dplyr)
library(ggplot2)

ny <- read_csv("data/nyt_database.csv")
movies <-  read_csv("data/box_office_database.csv")
guardian <- read_csv("data/guardian_database.csv")
bill <- read_csv("data/billboard_database.csv")

data <-  guardian |> 
  left_join(bill2, by = "date") |> 
  left_join(ny, by = "date") |> 
  left_join(movies, by = "date")

bill2 <- bill |> 
  complete(date = seq(min(date), max(date), by = "day")) %>%
  fill(-date, .direction = "up")


# Interfaz de usuario
ui <- fluidPage(
  titlePanel("Movie, Song and News of the day"),
  sidebarLayout(
    sidebarPanel(
      dateInput("date", "Choose a date:", value = Sys.Date(), format = "yyyy-mm-dd", startview = "month", weekstart = 1)
    ),
    mainPanel(
      h3("Most succesful movie:"),
      textOutput("best_selling"),
      uiOutput("image"),
      
      h3("Number 1 song on Billboard"),
      textOutput("song"),
      uiOutput("image_url"),
      
      h3("Headlines of the day"),
      textOutput("title"),
      textOutput("subtitle"),
      textOutput("headline"),
      textOutput("abstract")
    )
  )
)

# Functioning of the webpage
server <- function(input, output) {
  
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
      img(src = best_selling$image, height = "300px")
    }
  })
  
  output$song <- renderText({
    song <- filtered_data()
    if (nrow(song) > 0) return(song$song) else return("here is no data for this day")
  })
  
  output$image_url <- renderUI({
    song <- filtered_data()
    if (nrow(song) > 0) {
      img(src = song$image_url, height = "300px")
    }
  })
  
  output$title <- renderText({
    headlines <- filtered_data()
    if (nrow(headlines) > 0) return(headlines$title) else return("")
  })
  
  output$subtitulo1 <- renderText({
    headlines <- filtered_data()
    if (nrow(headlines) > 0) return(headlines$subtitle) else return("")
  })
  
  output$titular2 <- renderText({
    headlines <- filtered_data()
    if (nrow(headlines) > 0) return(headlines$headline) else return("")
  })
  
  output$subtitulo2 <- renderText({
    headlines <- filtered_data()
    if (nrow(headlines) > 0) return(headlines$abstract) else return("")
  })
}


# Ejecutar la aplicación
shinyApp(ui = ui, server = server)
