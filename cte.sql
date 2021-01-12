--Number of games per gameweek where total goals are more than / equal to 6
WITH match_list AS (
SELECT
m.match_id FROM scores m
WHERE (hometeam_goal + awayteam_goal) >= 6)
SELECT g.name AS gameweek, COUNT(match_list.match_id) AS matches
FROM scores
JOIN gameweek AS g
ON scores.gameweek_id = g.id
LEFT JOIN match_list ON scores.match_id = match_list.match_id
GROUP BY g.name
ORDER BY matches DESC

--Matches where 4 or more goals were scored
WITH match_list AS (
SELECT
scores.gameweek_id, m.date, hometeam_goal, awayteam_goal, (hometeam_goal + awayteam_goal) AS total_goals
	FROM scores
	LEFT JOIN match m ON scores.match_id = m.id)
SELECT gameweek_id, date, hometeam_goal, awayteam_goal FROM match_list
WHERE total_goals >= 4  

--Number of goals scored on AVG per venue in January
WITH match_list AS (
SELECT
venue_id, (hometeam_goal + awayteam_goal) AS goals
	FROM scores
	WHERE id IN (SELECT id FROM match 
				WHERE  EXTRACT(MONTH FROM date) = 01))
SELECT v.name, AVG(match_list.goals)
FROM venues v
LEFT JOIN match_list 
ON v.id = match_list.venue_id
GROUP BY v.name
ORDER BY avg DESC

--Full scoresheet using CTE
WITH team1 AS (
SELECT s.match_id, m.date, t.name AS team1, s.hometeam_goal
FROM scores s
LEFT JOIN teams t
ON t.id = s.hometeam_id
LEFT JOIN match m
ON s.match_id = m.id),
team2 AS (
SELECT s.match_id, m.date, t.name AS team2, s.awayteam_goal
FROM scores s
LEFT JOIN teams t
ON t.id = s.awayteam_id
LEFT JOIN match m
On s.match_id = m.id)
SELECT team1.date, team1.team1, team2.team2, team1.hometeam_goal, team2.awayteam_goal
FROM team1
JOIN team2
On team1.match_id = team2.match_id
ORDER BY date


--Full Scoresheet for Chelsea this season
WITH home AS(
	SELECT s.match_id, t.name,
CASE WHEN s.hometeam_goal > s.awayteam_goal THEN 'Chelsea Win'
WHEN s.hometeam_goal < s.awayteam_goal THEN 'Chelsea Lost'
ELSE 'Draw' END AS ChelseaPL
FROM scores s
LEFT JOIN teams t
ON s.hometeam_id = t.id),
away AS (
SELECT s.match_id, t.name,
CASE WHEN s.hometeam_goal > s.awayteam_goal THEN 'Chelsea Lost'
WHEN s.hometeam_goal < s.awayteam_goal THEN 'Chelsea Win'
ELSE 'Draw' END AS ChelseaPL
FROM scores s
LEFT JOIN teams t
ON s.awayteam_id = t.id)
SELECT DISTINCT m.date, home.name AS team1, away.name AS team2, hometeam_goal, awayteam_goal
FROM scores s
JOIN match m ON s.match_id = m.id
JOIN home ON s.match_id = home.match_id
JOIN away ON s.match_id = away.match_id
WHERE home.name = 'Chelsea' OR away.name = 'Chelsea'
