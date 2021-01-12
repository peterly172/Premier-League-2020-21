--Identify home wins, losses or draw
SELECT match_id,
CASE WHEN hometeam_goal > awayteam_goal THEN 'Home Win!'
WHEN hometeam_goal < awayteam_goal THEN 'Away Win!'
ELSE 'Draw' END AS outcome
FROM scores

--Select matches where Burney were home
SELECT s.match_id, t.name,
CASE WHEN hometeam_goal > awayteam_goal THEN 'Burnley Win'
WHEN hometeam_goal < awayteam_goal THEN 'Burnley loss!'
ELSE 'Draw' END AS Outcome
FROM scores s
JOIN teams t
ON s.awayteam_id = t.id
WHERE hometeam_id = 4

--Identify when Wolves won a match during the season
SELECT m.date, s.name, v.name, 
CASE WHEN scores.hometeam_id = 20 AND hometeam_goal > awayteam_goal THEN 'Wolves win'
WHEN scores.awayteam_id = 20 AND awayteam_goal > hometeam_goal THEN 'Wolves win'
END AS outcome
FROM scores
JOIN match m
ON scores.match_id = m.id
JOIN gameweek g
ON scores.gameweek_id = g.id
JOIN venues v
ON scores.venue_id = v.id

--Sum the total records in each gameweek where the home teams won (1-7)
SELECT g.name AS Gameweek,
SUM(CASE WHEN gameweek_id = 1 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_1,
SUM(CASE WHEN gameweek_id = 2 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_2,
SUM(CASE WHEN gameweek_id = 3 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_3,
SUM(CASE WHEN gameweek_id = 4 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_4,
SUM(CASE WHEN gameweek_id = 5 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_5,
SUM(CASE WHEN gameweek_id = 6 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_6,
SUM(CASE WHEN gameweek_id = 7 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_7
FROM scores 
JOIN gameweek g
ON scores.gameweek_id = g.id
WHERE gameweek BETWEEN 1 AND 7
GROUP BY s.name

--Count the Team1, Team2 and Draws in each Stadium
SELECT v.name AS venue,
COUNT(CASE WHEN hometeam_goal > awayteam_goal THEN s.id END) AS home_wins,
COUNT(CASE WHEN hometeam_goal < awayteam_goal THEN s.id END) AS away_wins,
COUNT(CASE WHEN hometeam_goal = awayteam_goal THEN s.id END) AS Draw
FROM scores s
JOIN venues v
ON s.venue_id = v.id
GROUP BY venue
ORDER BY home_wins DESC
