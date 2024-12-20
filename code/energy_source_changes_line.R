# Load Required Libraries 
library(ggplot2)
library(dplyr)

# Prepare Data 
energy_bar_data <- energy_types %>%
  filter(type != "Pumped hydro power") %>%  # Exclude "Pumped hydro power" as it's not a primary source
  mutate(
    type = ifelse(type %in% c("Geothermal", "Other"), "Geothermal & Other", type)  # Group "Geothermal" and "Other" into one category
  ) %>%
  group_by(type) %>% # Group by energy source
  summarise(
    `2016` = sum(`2016`, na.rm = TRUE), # Aggregate production for each year
    `2017` = sum(`2017`, na.rm = TRUE),
    `2018` = sum(`2018`, na.rm = TRUE)
  ) %>%
  pivot_longer(
    cols = c(`2016`, `2017`, `2018`),  # Convert year columns to long format
    names_to = "Year",
    values_to = "Production"
  )
# Create Small Multiples Charts 
## Energy Production Trends by Source (2016–2018)
ggplot(energy_bar_data)+
  aes(x = Year, 
      y = Production, 
      color = type, 
      group = type)+
  geom_line(size = 1.2) +
  geom_point(size = 3) +
  facet_wrap(~ type, scales = "free_y") +  # Create small multiples for each energy type with independent scales
  scale_color_manual(
    values = c( # Assign custom colors to each energy type
      "Conventional thermal" = "#cb9c00",
      "Nuclear" = "#ffa600",
      "Hydro" = "#115c06",
      "Wind" = "#416f00",
      "Solar" = "#6c8000",
      "Geothermal & Other" = "#998f00"
    )
  ) +
  labs(
    title = "Energy Production Trends by Source (2016–2018)", # Assign custom colors to each energy type
    x = "Year",
    y = "Production (GWh)"
  ) +
  theme_minimal() +  # Use a clean theme
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"), # Center and style the title
    strip.text = element_text(size = 12, face = "bold"),
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 12)
  )


