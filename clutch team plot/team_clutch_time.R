
library(rgdal)
library(png)
library(dplyr)
library(tidyr)
library(ggplot2)
#devtools::install_github('bart6114/artyfarty')
library('artyfarty')
clutch = read.csv('fetched.csv')
#number of games played vs number of wins
df1 = clutch[,c('GP','W','team')]
df1= gather(df1,type,count,-team)
#df1$count <-  ifelse(df1$type =="W",df1$count*(-1),df1$count)
temp = df1[df1$type=='GP',]
new_levels=  as.character(temp[order(temp$count),]$team)
df1$team = factor(df1$team,levels=new_levels)
#df1 <- within(df1, team <- factor(team, levels=names(sort(count,  decreasing=TRUE))))
df1 %>% ggplot(aes(x=team, y=count, fill=type))+
  geom_bar(stat="identity",position="identity")+
  xlab("number of games")+ylab("name of teams")+
  scale_fill_manual(name="type of games",values = pal("five38"))+
  coord_flip()+ggtitle("number of games played (GP) v.s number of wins (W)")+
  geom_hline(yintercept=0)+
  ylab("number of games")+
  xlab("team name")+
  scale_y_continuous(breaks = pretty(df1$count),labels = abs(pretty(df1$count)))+
  theme_scientific()

#Personal fouls (PF) and turnovers (TOV)

df1 = clutch[,c('PF','TOV','team')]
df1= gather(df1,type,count,-team)
df1$count <-  ifelse(df1$type =="PF",df1$count*(-1),df1$count)
temp = temp = df1[df1$type=='TOV',]
new_levels=  as.character(temp[order(temp$count),]$team)
df1$team = factor(df1$team,levels=new_levels)
#df1 <- within(df1, team <- factor(team, levels=names(sort(count,  decreasing=TRUE))))
df1 %>% ggplot(aes(x=team, y=count, fill=type))+
  geom_bar(stat="identity",position="identity")+
  xlab("counts")+ylab("name of teams")+
  scale_fill_manual(values = pal("five38"))+
  coord_flip()+ggtitle("Personal fouls (PF) and turnovers (TOV)")+
  geom_hline(yintercept=0)+
  ylab("counts")+
  xlab("team name")+
  scale_y_continuous(breaks = pretty(df1$count),labels = abs(pretty(df1$count)))+
  theme_scientific()



# divergent plot
df1 = clutch[,c('PCT_PTS_2PT','PCT_PTS_3PT','PCT_PTS_FT','team')]
df1= gather(df1,type,count,-team)
temp =  df1[df1$type=='PCT_PTS_2PT',]
new_levels=  as.character(temp[order(temp$count),]$team)
df1$team = factor(df1$team,levels=new_levels)
df1$count <-  ifelse(df1$type =="PCT_PTS_2PT",df1$count*(-1),df1$count)

df1 %>% ggplot(aes(x=team, y=count, fill=type))+
  geom_col()+
  xlab("percentage")+ylab("name of teams")+
  scale_fill_manual(values = pal("five38"))+
  coord_flip()+ggtitle("2PT%,3PT%,FT%")+
  geom_hline(yintercept=0)+
  ylab("percentage")+
  xlab("team name")+
  scale_y_continuous(breaks = pretty(df1$count),labels = abs(pretty(df1$count)))+
  theme_scientific()

#scatter
library(png)
library(ggplot2)
library(gridGraphics)
#setRepositories(ind=1:2)
#install.packages("ggimage")
library(ggimage)


setwd("logo/")
img <- readPNG("ATL.png")
g <- rasterGrob(img, interpolate=FALSE)

ggplot(df1, aes(x=OFF_RATING,y=DEF_RATING)) + 
  mapply(function(xx, yy, ii) {
    g$name <- ii
    annotation_custom(g, xmin=xx-1, xmax=xx+1, ymin=yy-0.2, ymax=yy+0.2)},
    df1$OFF_RATING, df1$DEF_RATING, seq_len(nrow(df1))) 

path = 'https://github.com/NiHaozheng/NBA-Visualization/blob/master/clutch_team/logo/'
#img <- "https://github.com/NiHaozheng/NBA-Visualization/blob/master/clutch_team/logo/ATL.png?raw=true"
df1 = clutch[,c('OFF_RATING','DEF_RATING','team')]
df1$img = paste(path,df1$team,'.png?raw=true',sep='')
ggplot(df1,aes(x=OFF_RATING,y=DEF_RATING))+geom_point()+
  scale_y_reverse()+geom_image(image = df1$img, size = .05)+
  theme_scientific()+
  xlab('offensive rating')+ylab('defensive rating')