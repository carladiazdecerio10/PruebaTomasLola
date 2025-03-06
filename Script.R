library(maptools)
library(ggplot2)
library(readxl)
library(dplyr)


dir.create("output", showWarnings = FALSE)

#Leer los datos
bee_data <- read.table("data/WBees.txt", header = TRUE, sep = "\t")
women_data <- read_excel("data/women.xlsx")

# Hacer operaciones sencillas
bee_summary <- bee_data %>%
  group_by(Hive) %>%
  summarise(Avg_CellSize = mean(CellSize, na.rm = TRUE))

women_summary <- women_data %>%
  summarise(across(where(is.numeric), mean, na.rm = TRUE))

# Generar gráfico y guardarlo en la carpeta output
ggplot(bee_data, aes(x = CellSize)) +
  geom_histogram(binwidth = 0.01, fill = "blue", alpha = 0.7) +
  ggtitle("Distribución de CellSize en WBees")
ggsave("output/bee_histogram.png")


write.csv(bee_summary, "output/bee_summary.csv", row.names = FALSE)
write.csv(women_summary, "output/women_summary.csv", row.names = FALSE)


# Congelar el entorno
renv::snapshot()

# Para restaurar el proyecto en otro equipo, ejecutar: 
# renv::restore()