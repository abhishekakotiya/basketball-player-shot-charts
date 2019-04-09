library(rjson)
library(ggplot2)

#Ginobili player id
#player_id <- 1938
#Duncan player id
#player_id <- 1495

statsNBAUrlstart <- "https://stats.nba.com/stats/shotchartdetail?AheadBehind=&CFID=33&CFPARAMS="
statsNBAUrlmid <- "&ClutchTime=&Conference=&ContextFilter=&ContextMeasure=FGA&DateFrom=&DateTo=&Division=&EndPeriod=10&EndRange=28800&GROUP_ID=&GameEventID=&GameID=&GameSegment=&GroupID=&GroupMode=&GroupQuantity=5&LastNGames=0&LeagueID=00&Location=&Month=0&OnOff=&OpponentTeamID=0&Outcome=&PORound=0&Period=0&PlayerID=1495&PlayerID1=&PlayerID2=&PlayerID3=&PlayerID4=&PlayerID5=&PlayerPosition=&PointDiff=&Position=&RangeType=0&RookieYear=&Season="
statsNBAUrlend <- "&SeasonSegment=&SeasonType=Regular+Season&ShotClockRange=&StartPeriod=1&StartRange=0&StarterBench=&TeamID=0&VsConference=&VsDivision=&VsPlayerID1=&VsPlayerID2=&VsPlayerID3=&VsPlayerID4=&VsPlayerID5=&VsTeamID="

seasons <- c("1998-99", "1999-00", "2000-01", "2001-02", "2002-03", "2003-04", "2004-05", "2005-06", "2006-07", "2007-08", "2008-09", "2009-10", "2010-11", "2011-12", "2012-13", "2013-14", "2014-15", "2015-16")

seasonURL <- "1997-98"
shotURL <- paste(statsNBAUrlstart, seasonURL, statsNBAUrlmid, seasonURL, statsNBAUrlend, sep = "")
shotDataRaw <- fromJSON(file = shotURL, method = "C")
shotData <- data.frame(matrix(unlist(shotDataRaw$resultSets[[1]][[3]]), ncol = 24, byrow = TRUE))

for (season in seasons) {
  print(season)
  seasonURL <- season
  shotURL <- paste(statsNBAUrlstart, seasonURL, statsNBAUrlmid, seasonURL, statsNBAUrlend, sep = "")
  shotDataRaw <- fromJSON(file = shotURL, method = "C")
  shotData <- rbind(shotData, data.frame(matrix(unlist(shotDataRaw$resultSets[[1]][[3]]), ncol = 24, byrow = TRUE)))
  
}

colnames(shotData) <- shotDataRaw$resultSets[[1]]$headers
shotData$LOC_X <- as.numeric(as.character(shotData$LOC_X))
shotData$LOC_Y <- as.numeric(as.character(shotData$LOC_Y))
shotData$SHOT_DISTANCE <- as.numeric(as.character(shotData$SHOT_DISTANCE))

shotChart <- ggplot(shotData, aes(x=LOC_X, y=LOC_Y)) + geom_point(aes(color=EVENT_TYPE)) + theme_void() + labs(title = "Tim Duncan Regular Season FG Made/Missed", color = "Field Goal") 
shotChart <- shotChart + scale_color_manual(values = c("Made Shot"="yellow", "Missed Shot"="green4")) + xlim(-250, 250) + ylim(-10, 450)
shotChart <- shotChart + theme(panel.background = element_rect(fill = "black"), panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank())
shotChart
