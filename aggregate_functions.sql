COUNT

-- Number of matches since in the Premier League so far (09/01/2021)
SELECT COUNT(match_id) AS total_matches
FROM scores

-- Number of matches taken place each stadium
SELECT v.name, COUNT(*) AS matches
FROM scores
JOIN venues AS v
ON scores.venue_id = v.id
GROUP BY v.name
ORDER BY matches DESC

--  Number of matches per gameweek
SELECT gameweek.name, COUNT(*) AS matches
FROM scores
JOIN gameweek 
ON scores.gameweek_id = gameweek.id
GROUP BY gameweek.name
ORDER BY matches DESC, gameweek.name




--What times do Crystal Palace play and how many times?
SELECT time, COUNT(*)
FROM match
WHERE hometeam_id = 6
OR awayteam_id = 6
GROUP BY time
ORDER BY COUNT(*)

--Top 10 Assist makers in the 2020-21 season
SELECT p.name AS player, COUNT(*) AS assists
FROM goals g
JOIN players p
ON g.assist_id = p.id
GROUP BY player
ORDER BY assists DESC
LIMIT 10

--Number of yellow cards given to West Ham
SELECT p.name AS player, COUNT(*) AS yellow_cards
FROM cards c
JOIN players p
ON c.player_id = p.id
WHERE c.team_id = 19
AND card_id = 1
GROUP BY player
ORDER BY yellow_cards DESC

--Number of goals scored by defenders
SELECT p.name AS player, COUNT(*)
FROM goals g
JOIN players p ON g.player_id = p.id
WHERE position_id = 2
GROUP BY p.name
ORDER BY goals DESC

--Number of strikers getting red cards
SELECT p.name AS player, COUNT(*) AS red_cards
FROM cards c
JOIN players p
ON c.player_id = p.id
WHERE position_id = 4
AND card_id = 2
GROUP BY p.name
ORDER BY red_cards DESC

--Total Number of goals scored in the each half
SELECT g.goal_half, COUNT(*) AS goals
FROM goals g
GROUP BY goal_half
ORDER BY goals DESC



--Number of yellow cards given in the first half
SELECT COUNT(*)
FROM cards c
WHERE card_time BETWEEN 1 AND 45

SUM
-- Number of goals scored so far in the Premier League
SELECT SUM(hometeam_goal + awayteam_goal)
FROM scores

--  Number of goals scored in each gameweek
SELECT gameweek.name, SUM(hometeam_goal + awayteam_goal) AS total_goals
FROM scores
JOIN gameweek
ON scores.gameweek_id = gameweek.id
GROUP BY gameweek.name 
ORDER BY total_goals DESC, gameweek.name

--Number of goals scored in each stadium
SELECT venues.name, SUM(hometeam_goal + awayteam_goal) AS total_goals
FROM scores
JOIN venues
ON scores.venue_id = venues.id
GROUP BY venues.name 
ORDER BY total_goals DESC

--Number of goals scored in each stadium capacity less than 40,000 capacity
SELECT venues.name, SUM(hometeam_goal + awayteam_goal) AS total_goals
FROM scores
JOIN venues
ON scores.venue_id = venues.id
WHERE capacity < 40000
GROUP BY venues.name 
ORDER BY total_goals DESC

--Number of goals scored in each stadium capacity of more than 40,000
SELECT venues.name, SUM(hometeam_goal + awayteam_goal) AS total_goals
FROM scores
JOIN venues
ON scores.venue_id = venues.id
WHERE capacity > 40000
GROUP BY venues.name 
ORDER BY total_goals DESC


MAX

-- Maximum number of goals scored in a single match at the PL season
SELECT MAX(hometeam_goal + awayteam_goal) FROM scores

--Maximum number of goals scored in a match per round
SELECT gameweek.name, MAX(hometeam_goal + awayteam_goal) AS max_goals
FROM scores
JOIN gameweek 
ON scores.gameweek_id = gameweek.id
GROUP BY gameweek.name
ORDER BY max_goals DESC, gameweek.name

--Maximum number of goals scored in a match per stadium
SELECT venues.name, MAX(hometeam_goal + awayteam_goal) AS max_goals
FROM scores
JOIN venues 
ON scores.venue_id = venues.id
GROUP BY venues.name
ORDER BY max_goals DESC

--Top 50 goals scored at the latest time this season
SELECT p.name, MAX(goal_time)
FROM goals g
JOIN players p
ON g.player_id = p.id
GROUP BY p.name
ORDER BY MAX(goal_time) DESC
LIMIT 50

--Earliest time goal scored this season
SELECT p.name, MIN(goal_time)
FROM goals g
JOIN players p
ON g.player_id = p.id
GROUP BY p.name
ORDER BY MIN(goal_time)
LIMIT 1 

--Earliest time card given this season
SELECT p.name, MIN(card_time)
FROM cards c
JOIN players p
ON c.player_id = p.id
GROUP BY p.name
ORDER BY MIN(card_time)
LIMIT 1

--Latest time card given this season
SELECT p.name, MAX(card_time)
FROM cards c
JOIN players p
ON c.player_id = p.id
GROUP BY p.name
ORDER BY MAX(card_time) DESC
LIMIT 1

UNION
--Displaying all matches and venues
SELECT gameweek_id, venue_id, hometeam_id, awayteam_id
FROM match
UNION 
SELECT gameweek_id, venue_id, hometeam_id, awayteam_id
FROM scores
ORDER BY gameweek_id, venue_id
 
SELECT gameweek_id, venue_id, hometeam_id, awayteam_id
FROM match
UNION ALL
SELECT gameweek_id, venue_id, hometeam_id, awayteam_id
FROM scores
ORDER BY gameweek_id, venue_id
