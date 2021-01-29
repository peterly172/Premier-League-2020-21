CREATE TRIGGER TR_player_insert 
ON players INSTEAD OF INSERT
AS BEGIN
DECLARE @id INT
DECLARE @name VARCHAR(100);
DECLARE @position_id INT;
DECLARE @team_id INT;
SELECT @id = id, @name = name, @position_id = position_id, @team_id = team_id FROM INSERTED;
IF @position_id IS NULL SET @position_id = 0
IF @team_id IS NULL SET @team_id = 0
INSERT INTO players(id, name, position_id, team_id) VALUES(@id, @name, @position_id, @team_id);
END

SELECT * FROM players
INSERT INTO players(id, name, team_id) VALUES(2100, 'Dean Matthews', 3);
SELECT * FROM players

CREATE TRIGGER TR_player_delete
ON players INSTEAD OF DELETE
AS BEGIN
DECLARE @id INT;
DECLARE @count INT;
SELECT @id = id FROM DELETED;
DELETE FROM players WHERE id = @id;
END;

DELETE FROM players WHERE id = 2100;