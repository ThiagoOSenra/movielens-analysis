# 📊 Análise Exploratória - MovieLens 100k

Este projeto tem como objetivo explorar e analisar a base de dados **MovieLens 100k**, amplamente utilizada em sistemas de recomendação. A análise foi desenvolvida com foco em compreender o comportamento dos usuários, os padrões de avaliação e a popularidade dos filmes por gênero.

## 🧰 Ferramentas utilizadas

- Linguagem: **R**
- Principais pacotes: `tidyverse`, `data.table`, `lubridate`, `ggplot2`, `cluster`, `scales`

---

## 🎯 Objetivos da Análise

- Explorar a distribuição das notas atribuídas pelos usuários;
- Investigar a média de avaliações ao longo do tempo;
- Avaliar a média e popularidade das avaliações por gênero;
- Segmentar os usuários com base em seu comportamento avaliativo por meio de clustering.

---

## 📌 Principais Resultados

### 🎞️ Média de Avaliações por Gênero
Filmes classificados como **Film-Noir**, **War** e **Drama** receberam, em média, as maiores notas. Isso pode indicar que esses gêneros possuem uma base de fãs mais engajada ou que os filmes disponíveis nessas categorias são, em geral, de alta qualidade.

### ⏱️ Média de Avaliações ao Longo do Tempo
Foram observadas flutuações nas médias de avaliação ao longo do tempo. Apesar de algumas quedas, há uma tendência geral de crescimento da média de notas, especialmente a partir do início de 1998, o que pode indicar uma mudança no perfil dos usuários ou nos filmes disponíveis na plataforma.

### 🔥 Popularidade por Gênero
**Drama**, **Comedy** e **Action** são os gêneros mais populares em número de avaliações. Isso reflete sua ampla aceitação e presença no catálogo da base de dados.

### 🧮 Distribuição das Notas
A maior parte das avaliações está concentrada nas notas **3** e **4**, com destaque para a nota **4** como a mais frequente. Isso sugere uma tendência dos usuários a atribuírem notas moderadamente altas, o que pode indicar uma predominância de experiências positivas.

### 👥 Clustering de Usuários
Foi aplicado o algoritmo **K-means** para segmentar os usuários com base na **média das suas avaliações** e no **total de avaliações realizadas**. Três clusters principais foram identificados:
- **Cluster 1**: usuários com poucas avaliações e notas medianas.
- **Cluster 2**: usuários muito ativos, com grande número de avaliações.
- **Cluster 3**: usuários com média de avaliação mais alta, mas moderadamente ativos.

---

## 📁 Organização do Projeto
📦 movielens-analysis 

.   ┣ 📂 dados 
   
.   ┃ ┗ 📄 u.data, u.item, u.genre...
   
.   ┣ 📂 plots 
   
.   ┃ ┗ 📊 Gráficos gerados pela análise 
   
.   ┣ 📜 README.md 
   
.     ┗ 📜 movielens-analysis.R
