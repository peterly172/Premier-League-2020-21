--Scorelist with the AVG
SELECT s.match_id, v.name AS venue, g.name AS gameweek, s.hometeam_goal, awayteam_goal,
AVG(hometeam_goal + awayteam_goal) OVER() AS overall_avg
FROM scores s
JOIN venues v ON s.venue_id = v.id
JOIN gameweek g ON s.gameweek_id = g.id



--Venue ranking on Average goals
SELECT v.name AS venue,
ROUND(AVG(hometeam_goal + awayteam_goal), 2) AS avg_goals,
RANK() OVER(ORDER BY AVG(hometeam_goal + awayteam_goal)DESC) AS venue_rank
FROM venues v
JOIN scores ON v.id = scores.venue_id
GROUP BY v.name
ORDER BY venue_rank

--Gameweek ranking on Average goals
SELECT g.name AS gameweek,
ROUND(AVG(hometeam_goal + awayteam_goal), 2) AS avg_goals,
RANK() OVER(ORDER BY AVG(hometeam_goal + awayteam_goal)DESC) AS gameweek_rank
FROM gameweek g
JOIN scores ON g.id = scores.gameweek_id
GROUP BY g.name
ORDER BY gameweek_rank

--Partitioning by a column
SELECT m.date, scores.venue_id, scores.hometeam_goal, scores.awayteam_goal,
CASE WHEN scores.hometeam_id = 9 THEN 'home' ELSE 'away' END AS Leeds,
AVG(hometeam_goal) OVER(PARTITION BY scores.venue_id) AS homeavg,
AVG(awayteam_goal) OVER(PARTITION BY scores.venue_id) AS awayavg
FROM scores
JOIN match m ON scores.match_id = m.id
JOIN gameweek g ON scores.gameweek_id = g.id
WHERE scores.hometeam_id = 9
OR scores.awayteam_id = 9
ORDER BY(hometeam_goal + awayteam_goal) DESC

--Assessing Running total of goals and AVG from Leicester when they are home
SELECT t.name AS team, gameweek.name, COUNT(*) AS goals,
SUM(COUNT(*)) OVER(ORDER BY match_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total 
FROM goals g
JOIN teams t ON g.team_id = t.id
JOIN match m ON g.match_id = m.id
JOIN gameweek ON m.gameweek_id = gameweek.id
WHERE team_id = 10
GROUP BY match_id, gameweek.name, t.name
