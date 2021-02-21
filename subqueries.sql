SUBQUERIES

--Teams who scored 4 or more goals as Home
SELECT t.name
FROM teams t
WHERE t.id IN (SELECT hometeam_id FROM scores WHERE hometeam_goal >= 4)

--Teams who scored 4 or more goals as Away
SELECT t.name
FROM teams t
WHERE t.id IN (SELECT awayteam_id FROM scores WHERE awayteam_goal >= 4)


--Matches where 5 or more goals were score in a match
SELECT date, hometeam_goal, awayteam_goal
FROM
(SELECT date, g.name, hometeam_goal, awayteam_goal, (hometeam_goal + awayteam_goal) AS total_goals
FROM scores
JOIN match m
ON scores.match_id = m.id
JOIN gameweek g
ON scores.gameweek_id = g.id) AS subq
WHERE total_goals >= 5

--Average total of goals per day vs. Overall AVG
SELECT g.name AS gameweek,
ROUND(AVG(hometeam_goal + awayteam_goal), 2) AS avg_goals,
(SELECT ROUND(AVG(hometeam_goal + awayteam_goal), 2)
FROM scores) AS Overall_avg
	  FROM scores
	  JOIN match AS m
	  ON scores.match_id = m.id
	  JOIN gameweek g
	  ON scores.gameweek_id = g.id
	  GROUP BY date, g.name
	  ORDER BY avg_goals DESC

--Average total of goals per gameweek vs Overall AVG
SELECT s.name AS gameweek,
ROUND(AVG(hometeam_goal + awayteam_goal), 2) AS avg_goals,
(SELECT ROUND(AVG(hometeam_goal + awayteam_goal), 2)
FROM scores) AS Overall_avg
	  FROM scores
	  LEFT JOIN match AS m
	  ON scores.match_id = m.id
	  JOIN gameweek s
	  ON scores.gameweek_id = s.id
	  GROUP BY s.name
	  ORDER BY avg_goals DESC

--Average total of goals per gameweek vs difference of overall AVG
SELECT g.name AS gameweek,
ROUND(AVG(hometeam_goal + awayteam_goal), 2) AS avg_goals,
ROUND(AVG(hometeam_goal + awayteam_goal) - 
	 (SELECT AVG(hometeam_goal + awayteam_goal)
	  FROM scores), 2) AS diff
 FROM scores
	  LEFT JOIN match AS m
	  ON scores.match_id = m.id
	  JOIN gameweek g
	  ON scores.gameweek_id = g.id
	  GROUP BY g.name
		ORDER BY avg_goals  DESC




--Gameweek where average goals > Overall AVG + Overall AVG
SELECT 
s.gameweek_id, ROUND(s.avg_goals, 2) AS AVG_goals,
(SELECT AVG(hometeam_goal + awayteam_goal) FROM scores) AS overall_AVG
FROM
(SELECT gameweek_id, AVG(hometeam_goal + awayteam_goal) AS avg_goals
FROM scores
GROUP BY gameweek_id) AS s
WHERE s.avg_goals > (SELECT AVG(hometeam_goal + awayteam_goal)
					FROM scores)

--Correlated subquery (matches where goals > twice the AVG
SELECT
main.gameweek_id,
main.hometeam_goal,
main.awayteam_goal
FROM scores AS main
WHERE
(hometeam_goal + awayteam_goal) >
(SELECT AVG((sub.hometeam_goal + sub.awayteam_goal) * 2)
FROM scores AS sub
WHERE main.gameweek_id = sub.gameweek_id)

--Scores equal Max number of goals in a match
SELECT 
main.match_id,
main.gameweek_id,
main.venue_id,
main.hometeam_goal,
main.awayteam_goal
FROM scores AS main
WHERE(hometeam_goal + awayteam_goal) =
(SELECT MAX(sub.hometeam_goal + sub.awayteam_goal)
FROM scores AS sub)

--Scores equal Min number of goals in a match
SELECT 
main.match_id,
main.gameweek_id,
main.venue_id,
main.hometeam_goal,
main.awayteam_goal
FROM scores AS main
WHERE(hometeam_goal + awayteam_goal) =
(SELECT MIN(sub.hometeam_goal + sub.awayteam_goal)
FROM scores AS sub)

--Comparing Max goals
SELECT g.name, MAX(hometeam_goal + awayteam_goal) AS max_goals,
(SELECT MAX(hometeam_goal + awayteam_goal) FROM scores) AS overall_max,
(SELECT MAX (hometeam_goal + awayteam_goal) 
FROM scores
WHERE match_id IN (SELECT id FROM match WHERE EXTRACT(MONTH FROM date) = 12)) AS dec_max_goals
FROM scores s
JOIN gameweek AS g
ON s.gameweek_id = g.id
GROUP BY g.name

--Matches where home or away score 4 or more goals
SELECT id, gameweek_id, venue_id
FROM scores
WHERE hometeam_goal >= 4 OR awayteam_goal >= 4

--Which gameweek and venue did those matches take place with > 4 goals?
SELECT
g.name AS gameweek, v.name AS venue, COUNT(subquery.match_id) AS matches
FROM (
SELECT gameweek_id, venue_id, match_id
FROM scores
WHERE hometeam_goal >= 2 OR awayteam_goal >= 2) AS subquery
JOIN gameweek g
ON g.id = subquery.gameweek_id
JOIN venues v
ON v.id = subquery.venue_id
GROUP BY g.name, v.name	  


--Venues where the top 5 earliest timed goals took place
SELECT v.name, sub.min_goal_time
FROM scores s
JOIN venues v
ON s.venue_id = v.id,
(SELECT match_id, p.name, MIN(goal_time) AS min_goal_time
FROM goals g
JOIN players p
ON g.player_id = p.id
GROUP BY match_id, p.name
ORDER BY min_goal_time
LIMIT 5) AS sub
WHERE s.match_id = sub.match_id

--20 latest goals this season took place in which Venues?
SELECT v.name, sub.max_goal_time
FROM scores s
JOIN venues v
ON s.venue_id = v.id,
(SELECT match_id, p.name, MAX(goal_time) AS max_goal_time
FROM goals g
JOIN players p
ON g.player_id = p.id
GROUP BY match_id, p.name
ORDER BY max_goal_time DESC
LIMIT 20) AS sub
WHERE s.match_id = sub.match_id
ORDER BY sub.max_goal_time DESC


--Venues where the 10 earliest yellow cards are given
SELECT v.name, sub.yellow_cards
FROM scores s
JOIN venues v
ON s.venue_id = v.id,
(SELECT match_id, p.name, MIN(card_time) AS yellow_cards
FROM cards c
JOIN players p
ON c.player_id = p.id
GROUP BY match_id, p.name
ORDER BY yellow_cards ASC
LIMIT 10) AS sub
WHERE s.match_id = sub.match_id
ORDER BY sub.yellow_cards

--10 latest yellow cards were given in which venues?
SELECT v.name, sub.yellow_cards
FROM scores s
JOIN venues v
ON s.venue_id = v.id,
(SELECT match_id, p.name, MAX(card_time) AS yellow_cards
FROM cards c
JOIN players p
ON c.player_id = p.id
GROUP BY match_id, p.name
ORDER BY yellow_cards DESC
LIMIT 10) AS sub
WHERE s.match_id = sub.match_id
ORDER BY sub.yellow_cards DESC



--Full scoresheet using a Subquery
SELECT m.date, team1, team2, hometeam_goal, awayteam_goal 
FROM scores s
JOIN match m
ON s.match_id = m.id
LEFT JOIN (
SELECT match.id, t.name AS team1
FROM match
JOIN teams t
ON match.hometeam_id = t.id) AS team1
ON team1.id = s.match_id
LEFT JOIN (
SELECT match.id, t.name AS team2
FROM match
JOIN teams t
ON match.awayteam_id = t.id) AS team2
ON team2.id = s.match_id
ORDER BY date

--Full scoresheet using a correlated subquery
SELECT m.date, team1, team2, hometeam_goal, awayteam_goal 
FROM scores s
JOIN match m
ON s.match_id = m.id
LEFT JOIN (
SELECT match.id, t.name AS team1
FROM match
JOIN teams t
ON match.hometeam_id = t.id) AS team1
ON team1.id = s.match_id
LEFT JOIN (
SELECT match.id, t.name AS team2
FROM match
JOIN teams t
ON match.awayteam_id = t.id) AS team2
ON team2.id = s.match_id
ORDER BY date
