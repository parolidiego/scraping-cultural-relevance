library(rvest)
library(xml2)
library(httr)
library(tidyverse)
library(janitor)
library(glue)

Sys.setlocale("LC_TIME", "English_United States.UTF-8")


# Should we add here who we are for ethical web scraping

# Specify years for the scraper
years <- seq(2023, 2000, by = -1)

# Build the urls from the years
urls <- glue("https://www.boxofficemojo.com/daily/{years}/?view=year")

# Get best selling movie by date
movies <- function(url, year) {
  Sys.sleep(2)
  
  page <- read_html(url)
  
  # Extract the table and select relevant columns
  movies <- page |> 
    html_table() %>%
    .[[1]] |> 
    select(`#1 Release`, Gross, Date) 
  
  # Clean the columns
  movies <- movies  |> 
    mutate(day = gsub("\\D", "", substr(Date, 1, 6)),
           month = substr(Date, 1, 3),
           year = year) |>  
    mutate(date = paste(day, month, year, sep = " "),
           date = as.Date(date, format = "%d %b %Y")) |> 
    select(-c(Date, day, month, year)) |> 
    mutate(Gross = as.numeric(gsub("\\D", "", Gross))) |> 
    rename(
      daily_earnings = Gross,
      best_selling = "#1 Release"
    )
  
  return(movies)
}

movies_per_day <- map2_dfr(urls, years, movies)



# Get the links of all top selling movies to access their info
links <- function(url) {
  Sys.sleep(2)
  
  page <- read_html(url)
  
  links <- page |> 
    xml_find_all("//td[@class = 'a-text-left mojo-field-type-release mojo-cell-wide']//a") |> 
    xml_attr(attr = "href") |> 
    str_remove_all("_\\d+$") |> 
    unique() %>% 
    paste0("https://www.boxofficemojo.com", .)
  
  return(links)
}

links_for_info <- map(urls, links)
links <- links_for_info |> unlist()



# Extract additional info about each top selling movie
extract_movie_info <- function(url) {
  Sys.sleep(2)
  
  ind_movie <- read_html(url)
  
  # Scraping the title
  title <- ind_movie |> 
    xml_find_all("//h1[@class = 'a-size-extra-large']") |> 
    xml_text() 
  
  # Scraping the movie's description
  description <- ind_movie |> 
    xml_find_all("//p[@class='a-size-medium']")
  description <- ifelse(length(description) >1, NA, xml_text(description))
  
  # Scraping the url of the image
  image <- ind_movie |> 
    xml_find_all("//div[@class = 'a-fixed-left-grid']//img") |> 
    xml_attr(attr = "data-a-hires") %>%
    .[[1]]
  
  # Scraping the earning box on the left (Grosses)
  money_elements <- ind_movie |> xml_find_all("//span[@class='money']")
  worldwide_earnings <- ifelse(length(money_elements) >= 3, 
                               xml_text(money_elements[[3]]), NA)
  opening_day_earnings <- ifelse(length(money_elements) >= 4, 
                                 xml_text(money_elements[[4]]), NA)
  
  # Extracting all info from the rest of the box as a vector
  # Middle column are odd numbers and right column is even numbers
  info <- ind_movie |>
    xml_find_all("//div[@class = 'a-section a-spacing-none mojo-summary-values mojo-hidden-from-mobile']//span[not(@*)]") |>
    xml_text(trim = TRUE)

  if (length(info) == 0) {
    
    return(tibble(title, description, image, 
                  worldwide_earnings, opening_day_earnings))
    
  }

  cols <- info[seq(1, length(info), by = 2)]
  values <- info[seq(2, length(info), by = 2)]
  
  info_tibble <- as_tibble(as.data.frame(t(values)))
  colnames(info_tibble) <- cols

  info_tibble <- info_tibble |> 
    mutate(opening_day_earnings = opening_day_earnings, .before = everything()) |> 
    mutate(worldwide_earnings = worldwide_earnings, .before = everything()) |> 
    mutate(image = image, .before = everything()) |>
    mutate(description = description, .before = everything()) |> 
    mutate(title = title, .before = everything())
  
  return(info_tibble)
}

best_selling_info <- map(links, extract_movie_info)
best_selling_info <- bind_rows(best_selling_info)

best_selling_info_cleaned <- best_selling_info |> 
  mutate(
    worldwide_earnings = as.numeric(str_replace_all(worldwide_earnings, "\\D", "")),
    opening_day_earnings = as.numeric(str_replace_all(opening_day_earnings, "\\D", "")),
    Budget = as.numeric(str_replace_all(Budget, "\\D", "")),
    Distributor = str_replace_all(Distributor, "See full.*", ""),
    Genres = str_replace_all(Genres, "\\n|\\s{2,}", "-"),
    `Release Date` = str_replace_all(`Release Date`, "\\n|\\s{2,}", " ")) |>
  mutate(Genres = str_replace_all(Genres, "--", " - ")) |> 
  select(-c("Release Date\n        \n            (Wide)", "IMDbPro", "Opening")) |> 
  rename(
    distributor = Distributor,
    release_date = `Release Date`,
    mpaa_rating = MPAA,
    running_time = `Running Time`,
    genres = Genres,
    in_release = `In Release`,
    widest_release = `Widest Release`,
    budget = Budget
  )
  
final_best_selling_movies <- movies_per_day |> 
  left_join(best_selling_info_cleaned, by = join_by("best_selling"=="title"))

write.csv(final_best_selling_movies, "data/box_office_database.csv")
