CREATE TABLE goals_audit (
id INT,
audit VARCHAR(100)
);

CREATE TRIGGER tr_Goals_Insert
ON goals
FOR INSERT
AS 
BEGIN
DECLARE @match_id INT
DECLARE @player_id INT
DECLARE @team_id INT
DECLARE @goal_time INT
DECLARE @goal_half INT
DECLARE @assist_id INT

SELECT @match_id = match_id, @player_id = player_id, @team_id = team_id, @goal_time = goal_time, @goal_half = goal_half, @assist_id = assist_id FROM INSERTED

INSERT INTO goals_audit (id, audit) VALUES(@match_id, 'A goal has been added scored by player ID number = ' + Cast(@player_id AS NVARCHAR(5)) +' ' + 'by Team ID number' + ' ' + Cast(@team_id AS NVARCHAR(5))
)

END

SELECT * FROM goals
INSERT INTO goals (match_id, player_id, team_id, goal_time, goal_half, assist_id) VALUES (1205, 3206, 12, 56, 2, 3209);
SELECT * FROM goals_audit

CREATE TRIGGER tr_goals_Delete
ON goals
FOR DELETE
AS
BEGIN
DECLARE @match_id INT
SELECT @match_id = match_id FROM DELETED

INSERT INTO goals_audit (id, audit) VALUES (@match_id, 'The goal(s) from match ID = ' + Cast(@match_id AS NVARCHAR(5)) + ' ' + 'has been deleted')

END


CREATE TRIGGER TR_goals_forupdate
ON goals
FOR UPDATE
AS 
BEGIN
DECLARE @match_id INT
DECLARE @OldPlayer_id INT, @NewPlayer_id INT
DECLARE @OldTeam_id INT, @NewTeam_id INT
DECLARE @OldGoal_time INT, @NewGoal_time INT
DECLARE @OldGoal_half INT, @NewGoal_half INT
DECLARE @OldAssist_id INT, @NewAssist_id INT

DECLARE @AuditString NVARCHAR(100) 

SELECT * INTO #temptable FROM INSERTED

WHILE(EXISTS(SELECT match_id FROM #temptable))
BEGIN
SET @AuditString = ''

SELECT TOP 1 @match_id = match_id, @NewPlayer_id = player_id, @NewTeam_id = team_id, @NewGoal_time = goal_time, @NewGoal_half = goal_half, @NewAssist_id = assist_id FROM #temptable

SELECT @OldPlayer_id = player_id, @OldTeam_id = team_id, @OldGoal_time = goal_time, @OldGoal_half = goal_half, @OldAssist_id = assist_id FROM DELETED WHERE match_id = @match_id

SET @AuditString = 'Data with Match_id = ' + Cast(@match_id AS NVARCHAR(5)) + ' ' + 'has changed'
IF (@OldPlayer_id <> @NewPlayer_id)
SET @AuditString = @AuditString + ' Player_ID from ' + Cast(@OldPlayer_id AS NVARCHAR(5)) + ' to ' + Cast(@NewPlayer_id AS NVARCHAR(5)) 

IF (@OldTeam_id <> @NewTeam_id)
SET @AuditString = @AuditString + ' Team_ID from ' + CAST(@OldTeam_id AS NVARCHAR(5)) + ' to ' + Cast(@NewTeam_id AS NVARCHAR(5)) 


INSERT INTO goals_Audit (id, audit) VALUES(@match_id, @AuditString)
DELETE FROM #TempTable WHERE match_id = @match_id

END

END

SELECT * FROM goals

SELECT * FROM goals_Audit

INSERT INTO goals (match_id, player_id, team_id, goal_time, goal_half, assist_id) VALUES (1207, 2114, 1, 45, 1, 2109) 
UPDATE goals SET player_id = 2808, team_id = 8 WHERE match_id = 1207
SELECT * FROM goals_Audit

CREATE VIEW vPlayerDetails
AS 
SELECT players.id, players.name AS player, p.name AS position, t.name AS team
FROM players
JOIN positions p ON players.position_id = p.id
JOIN teams t ON players.team_id = t.id

SELECT * FROM vPlayerDetails

CREATE TRIGGER vPlayerDetails_InsteadOfInsert
ON vPlayerDetails INSTEAD OF INSERT
AS
BEGIN
	SELECT * FROM INSERTED
	SELECT * FROM DELETED
END



ALTER TRIGGER vPlayerDetails_InsteadOfInsert
ON vPlayerDetails INSTEAD OF INSERT
AS
BEGIN
BEGIN
	DECLARE @position_id INT
	DECLARE @team_id INT

	SELECT @position_id = positions.id FROM positions
	JOIN INSERTED ON INSERTED.position = positions.name
	SELECT @team_id = teams.id FROM teams
	JOIN INSERTED ON INSERTED.team = teams.name

	IF(@position_id IS NULL)
	BEGIN
		RAISERROR('Please enter valid position', 16, 1)
		RETURN
	END

	IF(@team_id IS NULL)
	BEGIN
		RAISERROR('Please enter valid team name', 16, 1)
		RETURN
	END

	INSERT INTO players(id, name, position_id, team_id)
	SELECT id, player, @position_id, @team_id
	FROM INSERTED
	END
	END

CREATE TRIGGER tr_vPlayersDetails_InsteadOfUpdate
ON vPlayerDetails INSTEAD OF UPDATE
AS
BEGIN
	IF(UPDATE(id))
	BEGIN
		RAISERROR('ID cannot be changed', 16, 1)
		RETURN
	END

		IF(UPDATE(position))
	BEGIN
		DECLARE @position_id INT
		
		SELECT @position_id = positions.id
		FROM positions
		JOIN INSERTED
		ON INSERTED.position = positions.name

		IF(@position_id IS NULL)
		BEGIN
			RAISERROR('Invalid position', 16, 1)
			RETURN
		END

		UPDATE players SET position_id = @position_id
		FROM INSERTED
		JOIN players
		ON players.id = INSERTED.id
		END

			IF(UPDATE(team))
	BEGIN
		DECLARE @team_id INT

		SELECT @team_id = t.id
		FROM teams t
		JOIN INSERTED
		ON INSERTED.team = t.name

		IF(@team_id IS NULL)
		BEGIN
			RAISERROR('Invalid Team Name', 16, 1)
			RETURN
		END

		UPDATE players SET team_id = @team_id
		FROM INSERTED
		JOIN players p
		ON p.id = INSERTED.id
		END

		IF(UPDATE(player))
		BEGIN
			UPDATE players SET players.name = INSERTED.player
			FROM INSERTED
			JOIN players
			ON players.id = INSERTED.id
			END
	END

	INSERT INTO vPlayerDetails VALUES (2557, 'Peter Williams', 'Goalkeeper', 'Chelsea')
	SELECT * FROM vPlayerDetails
	UPDATE vPlayerDetails SET position = 'Batsman' WHERE id = 2557
	
CREATE VIEW vCardDetails
AS 
SELECT match_id, p.name AS player, t.name AS team, c.card AS colour, card_time
FROM cards
JOIN players p ON cards.player_id = p.id
JOIN teams t ON cards.team_id = t.id
JOIN colour c ON cards.card_id = c.id

INSERT INTO vCardDetails VALUES (1213, 'Peter Ly', 'Arsenal', 'Yellow', 87)

CREATE TRIGGER tr_vCardDetails_InsteadOfInsert
ON vCardDetails INSTEAD OF INSERT
AS
BEGIN
	SELECT * FROM INSERTED
	SELECT * FROM DELETED
END

ALTER TRIGGER tr_vCardDetails_InsteadOfInsert
ON vCardDetails INSTEAD OF INSERT
AS
BEGIN
	DECLARE @player_id INT
	DECLARE @team_id INT
	DECLARE @card_id INT

SELECT @player_id = players.id FROM players
JOIN INSERTED ON INSERTED.player = players.name
SELECT @team_id = teams.id FROM teams
JOIN INSERTED ON INSERTED.team = teams.name
SELECT @card_id = colour.id FROM colour
JOIN INSERTED ON INSERTED.colour = colour.card

IF (@player_id IS NULL)
BEGIN
	RAISERROR('Please enter valid player name', 16, 1)
	RETURN
END

IF (@team_id IS NULL)
BEGIN
	RAISERROR('Please enter valid team name', 16, 1)
	RETURN
END

IF (@card_id IS NULL)
BEGIN
	RAISERROR('Please enter valid card colour', 16, 1)
	RETURN
END

INSERT INTO cards (match_id, player_id, team_id, card_id, card_time)
SELECT match_id, @player_id, @team_id, @card_id, card_time
FROM INSERTED
END

SELECT * FROM vCardDetails

CREATE TRIGGER tr_vCardDetails_InsteadOfUpdate
ON vCardDetails INSTEAD OF UPDATE
AS
BEGIN
	IF(UPDATE(match_id))
	BEGIN
		RAISERROR('Match ID cannot be changed', 16, 1)
		RETURN
	END

		IF(UPDATE(player))
	BEGIN
		DECLARE @player_id INT
		
		SELECT @player_id = players.id
		FROM players
		JOIN INSERTED
		ON INSERTED.player = players.name

		IF(@player_id IS NULL)
		BEGIN
			RAISERROR('Invalid player', 16, 1)
			RETURN
		END

		UPDATE cards SET player_id = @player_id
		FROM INSERTED
		JOIN cards
		ON cards.match_id = INSERTED.match_id
		END

			IF(UPDATE(team))
	BEGIN
		DECLARE @team_id INT

		SELECT @team_id = t.id
		FROM teams t
		JOIN INSERTED
		ON INSERTED.team = t.name

		IF(@team_id IS NULL)
		BEGIN
			RAISERROR('Invalid Team Name', 16, 1)
			RETURN
		END

		UPDATE cards SET team_id = @team_id
		FROM INSERTED
		JOIN cards
		ON cards.match_id = INSERTED.match_id
		END

		IF(UPDATE(colour))
	BEGIN
		DECLARE @card_id INT

		SELECT @card_id = colour.id
		FROM colour
		JOIN INSERTED
		ON INSERTED.colour = colour.card

		IF(@card_id IS NULL)
		BEGIN
			RAISERROR('Invalid Card Colour', 16, 1)
			RETURN
		END

		UPDATE cards SET card_id = @card_id
		FROM INSERTED
		JOIN cards
		ON cards.match_id = INSERTED.match_id
		END

		IF(UPDATE(card_time))
		BEGIN
			UPDATE cards SET card_time = INSERTED.card_time
			FROM INSERTED
			JOIN cards
			ON cards.match_id = INSERTED.match_id
			END
	END

	SELECT * FROM vCardDetails

	INSERT INTO vCardDetails VALUES (1205, 'Ben Davies', 'Tottenham Hotspur', 'Red', 33)
	UPDATE vCardDetails SET colour = 'Purple'  WHERE match_id = 1205
 





