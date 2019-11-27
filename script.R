library(ggplot2)
library(dplyr)
library(gridExtra)


df <- read.csv('data/2.csv')
df$X.1 <- NULL

iter_count <- 10
iter_count_multiplier <- 5
sample_size <- 300 

b0s = data.frame(b0 = numeric(), iter_count = numeric())
b1s = data.frame(b1 = numeric(), iter_count = numeric())

get_sample <- function(df, sample_size){
  sample_n(df, sample_size)
}

for (j in 1:4) {
  for (i in 1:iter_count) {
    df_sample <- get_sample(df, sample_size)
    model <- lm(Y~X, df_sample)
    
    b0 <- coef(model)[1]
    b1 <- coef(model)[2]
    
    b0s <- rbind(b0s, data.frame(b0 = c(b0), iter_count = c(iter_count)))
    b1s <- rbind(b1s, data.frame(b1 = c(b1), iter_count = c(iter_count)))
  }
  iter_count <- iter_count*iter_count_multiplier
}

model <- lm(Y~X, df)

b0 <- coef(model)[1]
b1 <- coef(model)[2]

grid.arrange(b0s %>% 
               ggplot(aes(b0, fill='r', alpha = 0.3)) + 
               geom_density() + 
               geom_vline(xintercept = b0, color='red') +
               facet_wrap(.~iter_count) +
               theme(legend.position = "none"),
             b1s %>%
               ggplot(aes(b1, fill=1, alpha = 0.3)) + 
               geom_density() + 
               geom_vline(xintercept = b1, color='blue') +
               facet_wrap(.~iter_count) +
               theme(legend.position = "none"),
             df %>% ggplot(aes(X, Y)) + geom_point())
