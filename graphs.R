library(tidyverse)
library(ggimage)

billboard <- read_csv("data/billboard_database.csv")

# Aggregate weeks at No. 1 per song
billboard <- billboard |> 
  group_by(song, artist, image_url) |> 
  summarise(weeks_at_1 = max(weeks_at_1), .groups = "drop") |> 
  arrange(desc(weeks_at_1)) |> 
  slice_max(weeks_at_1, n = 5)

# Plot
ggplot(billboard, aes(x = reorder(song, weeks_at_1), y = weeks_at_1, fill = artist)) +
  geom_col() +
  geom_text(aes(label = weeks_at_1), hjust = 2.5, color = "white", size = 5, fontface = "bold") +
  geom_image(aes(image = image_url), size = 0.1, by = "width", nudge_y = 1) + 
  coord_flip() +  # Horizontal bars
  labs(title = "Songs with Most Weeks at No.1 in the 21st century",
       x = "",
       y = "Weeks at No.1") +
  ylim(0,22) +
  theme_minimal() +
  theme(legend.position = "none",
        panel.grid = element_blank(), 
        axis.text.x = element_blank(),
        plot.title.position = "plot",
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.title.x = element_text(hjust = 0.35, face = "bold", size = 12))

movies <-  read_csv("data/box_office_database.csv")

movies <- movies |> 
  mutate(worldwide_earnings = as.numeric(worldwide_earnings)) |> 
  group_by(best_selling, image) |> 
  summarise(worldwide_earnings = max(worldwide_earnings), .groups = "drop") |> 
  arrange(desc(worldwide_earnings)) |> 
  slice_max(worldwide_earnings, n = 10) |> 
  mutate(worldwide_earnings = format(worldwide_earnings, big.mark = ",", decimal.mark = "."))

ggplot(movies, aes(x = reorder(best_selling, worldwide_earnings), y = worldwide_earnings, fill = best_selling)) +
  geom_col() +
  geom_text(aes(label = worldwide_earnings), hjust = 2.5, color = "white", size = 5, fontface = "bold") +
  geom_image(aes(image = image), size = 0.1, by = "width", nudge_y = 1) + 
  coord_flip() +  # Horizontal bars
  labs(title = "Songs with Most Weeks at No.1 in the 21st century",
       x = "",
       y = "Weeks at No.1") +
  theme_minimal() +
  theme(legend.position = "none",
        panel.grid = element_blank(), 
        axis.text.x = element_blank(),
        plot.title.position = "plot",
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.title.x = element_text(hjust = 0.35, face = "bold", size = 12))


movies_top10 <- movies |> 
  mutate(worldwide_earnings = as.numeric(worldwide_earnings)) |> 
  group_by(best_selling, image) |> 
  summarise(worldwide_earnings = max(worldwide_earnings), .groups = "drop") |> 
  arrange(desc(worldwide_earnings)) |> 
  slice_max(worldwide_earnings, n = 10)

# Plot
ggplot(movies_top10, aes(x = reorder(best_selling, worldwide_earnings), y = worldwide_earnings, fill = best_selling)) +
  geom_col() +
  geom_text(aes(label = paste("$", format(worldwide_earnings, big.mark = ",", decimal.mark = "."))),
            color = "white", size = 3, fontface = "bold", hjust = 1.5) +  
  geom_image(aes(image = image), size = 0.08, by = "width", nudge_y = 1) +  
  coord_flip() +  
  labs(title = "Top 10 Highest-Grossing Movies in the 21st century",
       x = "",
       y = "Worldwide Earnings") +
  theme_minimal() +
  theme(legend.position = "none",
        panel.grid = element_blank(), 
        axis.text.x = element_blank(),
        plot.title.position = "plot",
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.title.x = element_text(hjust = 0.5, face = "bold", size = 12))
  