# 📦 Carregar pacotes
if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, data.table, lubridate, ggplot2, cluster, scales)

# 📁 Carregar os dados
ratings <- fread("dados/u.data", col.names = c("user_id", "movie_id", "rating", "timestamp"))
movies <- fread("dados/u.item", sep = "|", header = FALSE, encoding = "Latin-1",
                select = c(1, 2, 6:24), col.names = c("movie_id", "title", paste0("genre_", 1:19)))

# 🕓 Converter timestamp
ratings <- ratings %>%
  mutate(date = as_datetime(timestamp))

# 🎭 Gêneros em formato longo
movies_long <- movies %>%
  pivot_longer(cols = starts_with("genre_"), names_to = "genre", values_to = "has_genre") %>%
  filter(has_genre == 1) %>%
  select(movie_id, title, genre) %>%
  mutate(genre = str_replace(genre, "genre_", ""))

genre_mapping <- c("Unknown", "Action", "Adventure", "Animation", "Children", "Comedy", "Crime",
                   "Documentary", "Drama", "Fantasy", "Film-Noir", "Horror", "Musical", "Mystery",
                   "Romance", "Sci-Fi", "Thriller", "War", "Western")
movies_long$genre <- genre_mapping[as.numeric(movies_long$genre)]

# 🔗 Juntar ratings com gêneros
ratings_genre <- ratings %>%
  inner_join(movies_long, by = "movie_id")

# 📊 Análise 1: Média de avaliação por gênero
genre_ratings <- ratings_genre %>%
  group_by(genre) %>%
  summarise(avg_rating = mean(rating), .groups = 'drop') %>%
  arrange(desc(avg_rating))

ggplot(genre_ratings, aes(x = reorder(genre, avg_rating), y = avg_rating)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Média de Avaliações por Gênero", x = "Gênero", y = "Média") +
  theme_minimal()

# 📈 Análise 2: Evolução da média das avaliações ao longo do tempo
temporal_ratings <- ratings %>%
  mutate(date = floor_date(date, unit = "month")) %>%
  group_by(date) %>%
  summarise(avg_rating = mean(rating), .groups = 'drop')

ggplot(temporal_ratings, aes(x = date, y = avg_rating)) +
  geom_line(color = "darkgreen") +
  geom_smooth(method = "loess", se = FALSE, color = "black", linetype = "dashed") +
  labs(title = "Média de Avaliação ao Longo do Tempo", x = "Data", y = "Média") +
  scale_x_datetime(date_labels = "%b/%y", date_breaks = "3 months") +
  theme_minimal()

# 📈 Análise 3: Popularidade por gênero
genre_popularity <- ratings_genre %>%
  count(genre, sort = TRUE)

ggplot(genre_popularity, aes(x = reorder(genre, n), y = n)) +
  geom_col(fill = "darkorange") +
  coord_flip() +
  labs(title = "Popularidade por Gênero", x = "Gênero", y = "Número de Avaliações") +
  theme_minimal()

# 🧪 Análise 4: Distribuição das avaliações
ggplot(ratings, aes(x = rating)) +
  geom_bar(fill = "purple", alpha = 0.7) +
  labs(title = "Distribuição das Notas", x = "Nota", y = "Frequência") +
  theme_minimal()

# 👤 Análise 5: Perfis de usuários
user_profiles <- ratings_genre %>%
  group_by(user_id) %>%
  summarise(
    avg_rating = mean(rating),
    sd_rating = sd(rating),
    total_ratings = n(),
    n_genres = n_distinct(genre),
    .groups = 'drop'
  ) %>%
  replace_na(list(sd_rating = 0))

# 🤖 Clustering de usuários (K-means)
set.seed(123)
kmeans_result <- kmeans(user_profiles[, c("avg_rating", "sd_rating", "total_ratings", "n_genres")], centers = 3)
user_profiles$cluster <- as.factor(kmeans_result$cluster)

# 📊 Visualização dos clusters
ggplot(user_profiles, aes(x = avg_rating, y = total_ratings, color = cluster)) +
  geom_point(alpha = 0.7) +
  labs(title = "Clusters de Usuários", x = "Média de Avaliação", y = "Total de Avaliações") +
  theme_minimal()

# 🧠 Análise por cluster
cluster_summary <- user_profiles %>%
  group_by(cluster) %>%
  summarise(across(c(avg_rating, sd_rating, total_ratings, n_genres), mean), .groups = 'drop')

print(cluster_summary)

# 💥 Outliers: usuários com comportamento extremo
ratings_extremos <- user_profiles %>%
  filter(avg_rating == 5 | avg_rating == 1) %>%
  arrange(desc(total_ratings))

print(head(ratings_extremos))
