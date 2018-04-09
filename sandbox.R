rm(list=ls())

library(data.table)
library(ggplot2)
library(microbenchmark)
library(dplyr)

set.seed(5)

######################################################################
# First snippet: CREATE DATA #########################################
######################################################################

date <- seq.Date(as.Date('2001-08-01'),as.Date('2001-08-14'),by='day')
dayname <- weekdays(date)

red <- sample(50:100,14)
green <- sample(20:40,14)
blue <- sample(40:80,14)

boats <- data.table(date, dayname, red, green, blue)

######################################################################
# Second snippet: MELT DATA ##########################################
######################################################################

tidy_boats <- melt(boats,id.vars=c('date','dayname'),measure.vars=c('red','green','blue'),variable.name='color',value.name='count')

######################################################################
# Third snippet: PLOT SLOPPY DATA ####################################
######################################################################

ggplot(boats,aes(x=date)) +
  geom_line(aes(y=red),color='red') +
  geom_line(aes(y=green),color='green') +
  geom_line(aes(y=blue),color='blue') +
  labs(x='',y='boats',title='Boats counted in Oslo')

######################################################################
# Third snippet: PLOT TIDY DATA ######################################
######################################################################

ggplot(tidy_boats,aes(x=date,y=count,col=color,group=color)) +
  geom_line() +
  labs(x='',y='boats',title='Boats counted in Oslo')

######################################################################
# Fourth snippet: PLOT TIDY DATA FACETS ##############################
######################################################################

ggplot(tidy_boats,aes(x=date,y=count)) +
  geom_line() +
  labs(x='',y='boats',title='Boats counted in Oslo') +
  facet_grid(.~color)

######################################################################
# Fifth snippet: MICROBENCHMARKS #####################################
######################################################################

microbenchmark(tidy_boats[,.(total=sum(count)),by=date])
microbenchmark(tidy_boats %>% group_by(color) %>% summarise(total=sum(count)))

microbenchmark(tidy_boats[color == 'green'])
microbenchmark(tidy_boats %>% filter(color == green))

microbenchmark(tidy_boats[,.(date,color,count)])
microbenchmark(tidy_boats %>% select(date,color,count))
