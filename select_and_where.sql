-- Scores from the first matchday
SELECT * FROM scores
WHERE gameweek_id = 1

-- Scores from first 10 gameweeks
SELECT * FROM scores
WHERE gameweek_id BETWEEN 1 AND 10

-- Scores that took place at Elland Road
SELECT * FROM scores
WHERE venue_id= 9


--Matches that took place within the Christmas and New Year
SELECT * FROM match
WHERE gameweek_id = 15 OR gameweek_id = 16

--Goals and Assists from Leicester City
SELECT * FROM goals 
WHERE team_id = 10

--Red Cards from West Bromwich Albion
SELECT * FROM cards 
WHERE team_id = 18
AND card_id = 2
