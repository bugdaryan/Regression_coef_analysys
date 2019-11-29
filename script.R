library(ggplot2)
library(dplyr)
library(gridExtra)


df <- read.csv('data/2.csv')
df$X.1 <- NULL



get_sample <- function(df, sample_size){
  sample_n(df, sample_size)
}

bs = data.frame(b0 = numeric(), b1=numeric(), var=numeric(), iter_count = numeric())
iter_count <- 10
iter_count_multiplier <- 5
sample_size <- 300 
for (j in 1:4) {
  for (i in 1:iter_count) {
    df_sample <- get_sample(df, sample_size)
    model <- lm(Y~X, df_sample)
    
    b0 <- coef(model)[1]
    b1 <- coef(model)[2]
    
    bs <- rbind(bs, data.frame(b0 = c(b0), b1 = c(b1),mean.X=mean(df_sample$X), mean.Y = mean(df_sample$Y), var=var(df_sample), iter_count = c(iter_count)))
  }
  iter_count <- iter_count*iter_count_multiplier
}

model <- lm(Y~X, df)

b0 <- coef(model)[1]
b1 <- coef(model)[2]

grid.arrange(bs %>% 
               ggplot(aes(b0, fill='r')) + 
               geom_histogram() + 
               geom_vline(xintercept = b0, color='red') +
               facet_wrap(.~iter_count) +
               theme(legend.position = "none"),
             bs %>%
               ggplot(aes(b1, fill=1)) + 
               geom_histogram() + 
               geom_vline(xintercept = b1, color='blue') +
               facet_wrap(.~iter_count) +
               theme(legend.position = "none"))
head(bs)

bs %>% group_by(iter_count) %>% summarise(mean.X = mean(mean.X), mean.Y=mean(mean.Y)  ,var.X = mean(var.X), var.Y=mean(var.Y))
var(df)
df %>% summarise(mean.X = mean(X), mean.Y=mean(Y))
