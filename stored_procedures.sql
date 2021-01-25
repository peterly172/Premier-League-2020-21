CREATE PROCEDURE Matchlist
AS
BEGIN
SELECT m.id, date, time, g.name AS gameweek, v.name AS venue, t1.name AS hometeam, t2.name AS awayteam
FROM match AS m
LEFT JOIN gameweek AS g
ON m.gameweek_id = g.id
LEFT JOIN venues AS v
ON m.venue_id = v.id
LEFT JOIN teams AS t1
ON m.hometeam_id = t1.id
LEFT JOIN teams AS t2
ON m.awayteam_id = t2.id
ORDER BY m.id
END

CREATE PROCEDURE Scoreslist
AS
BEGIN
SELECT match_id, g.name AS gameweek, v.name AS venue, t1.name AS hometeam, t2.name AS awayteam, hometeam_goal, awayteam_goal
FROM scores AS s
LEFT JOIN gameweek AS g
ON s.gameweek_id = g.id
LEFT JOIN venues AS v
ON s.venue_id = v.id
LEFT JOIN teams AS t1
ON s.hometeam_id = t1.id
LEFT JOIN teams AS t2
ON s.awayteam_id = t2.id
ORDER BY match_id
END

CREATE PROCEDURE G_and_A
AS 
BEGIN
SELECT match_id, p1.name AS goalscorer, t.name AS team, goal_time, goal_half, p2.name AS assist
FROM goals AS g
LEFT JOIN players AS p1
ON g.player_id = p1.id
LEFT JOIN teams AS t
ON g.team_id = t.id
LEFT JOIN players AS p2
ON g.assist_id = p2.id
ORDER BY match_id, goal_time
END

CREATE PROCEDURE Cardlist
AS
BEGIN
SELECT match_id, p.name AS player, t.name AS team, co.card, card_time
FROM cards AS ca
LEFT JOIN players AS p
ON ca.player_id = p.id
LEFT JOIN teams AS t
ON ca.team_id = t.id
LEFT JOIN colour AS co
ON ca.card_id = co.id
ORDER BY match_id, card_time
END

CREATE PROCEDURE creategoal
(
@match_id AS INT,
@player_id AS INT,
@team_id AS INT,
@goal_time AS INT,
@goal_half AS INT,
@assist_id AS INT
)
AS
BEGIN
INSERT INTO goals (match_id, player_id, team_id, goal_time, goal_half, assist_id) VALUES
(@match_id, @player_id, @team_id, @goal_time, @goal_half, @assist_id)
SELECT * FROM goals WHERE id = @@IDENTITY
END

CREATE PROCEDURE createcard
(
@match_id AS INT,
@player_id AS INT,
@team_id AS INT,
@card_id AS INT,
@card_time AS INT
)
AS
BEGIN
INSERT INTO cards (match_id, player_id, team_id, card_id, card_time) VALUES
(@match_id, @player_id, @team_id, @card_id, @card_time)
SELECT * FROM cards WHERE id = @@IDENTITY
END