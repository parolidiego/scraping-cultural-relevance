
library(rvest)
library(xml2)
library(httr)
library(tidyverse)
library(janitor)
library(glue)

add_date <- function(movies, year) {
  
  start <- as.numeric(as_date(glue("{year}-12-31")))
  
  movies <- movies %>% 
    mutate(date = seq(start, by = -1, length.out = n())) |> 
    mutate(date = as_date(date))
  
  return(movies)
}

extract_movie_info <- function(url) {
  
  ind_movie <- read_html(url)
  
  title <- ind_movie |> 
    xml_find_all("//h1[@class = 'a-size-extra-large']") |> 
    xml_text() 
  
  image <- ind_movie |> 
    xml_find_all("//div[@class = 'a-fixed-left-grid']//img") |> 
    xml_attr(attr = "data-a-hires") %>%
    .[[1]]
  
  opening_g <- ind_movie |> 
    xml_find_all("//div[@class = 'a-section a-spacing-none mojo-summary-values mojo-hidden-from-mobile']//span[@class = 'money']") |> 
    xml_text(trim = TRUE) %>%
    .[[1]] |> 
    str_remove_all("[^\\d]") |> 
    as.numeric()
  
  info <- ind_movie |> 
    xml_find_all("//div[@class = 'a-section a-spacing-none mojo-summary-values mojo-hidden-from-mobile']//span[not(@*)]") |> 
    xml_text(trim = TRUE)
  
  if (length(info) == 0) {
    return(tibble(title = title, image = image, opening = opening))
  }
  
  cols <- info[seq(1, length(info), by = 2)]
  values <- info[seq(2, length(info), by = 2)]
  
  info <- tibble(!!!setNames(as.list(values), cols)) |> 
    janitor::clean_names()
  
  automatic_columns <- c("title", "image", "opening", names(info))
  
  info <- info %>%
    mutate(genres = if ("genres" %in% names(.)) genres else NA) %>%
    mutate(across(everything(), ~ ifelse(is.null(.), NA, .))) |> # We include this because it can be columns that do not appear in the web
    mutate(image = image, .before = everything()) |> 
    mutate(title = title, .before = everything()) |> 
    mutate(opening = opening_g)
  
  info <- info |> 
    mutate(genres = if ("genres" %in% names(info)) str_split(genres, "\\s*\\n\\s*") else list(NA)) |> 
    mutate(genres = str_trim(genres)) 
  
  return(info)
}


movies <- function(url) {
 page <- read_html(url)
 
 movies <- page |> 
   html_table() %>%
   .[[1]] |> 
   select(`#1 Release`, Gross) 
 
 return(movies)
}

links <- function(url) {
  page <- read_html(url)
  
  links <- page |> 
    xml_find_all("//td[@class = 'a-text-left mojo-field-type-release mojo-cell-wide']//a") |> 
    xml_attr(attr = "href") |> 
    str_remove_all("_\\d+$") |> 
    unique() %>% 
    paste0("https://www.boxofficemojo.com", .)
  
  return(links)
}

years <- seq(2002,1998, by = -1)

urls <- glue("https://www.boxofficemojo.com/daily/{years}/?view=year")

movies_per_day <- map_dfr(urls, movies)
links_for_info <- map(urls, links)

movies <- add_date(prueba, 2002)

links <- prueba2 |> unlist()

info_peliculas <- map_dfr(links, extract_movie_info)

