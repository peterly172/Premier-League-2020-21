CREATE FUNCTION dbo. fnGetTotalGoalsByPlayer
(
@player_id AS INT
)
RETURNS INT
AS
BEGIN
	DECLARE @goals AS INT
	SELECT
	@goals = COUNT(*)
	FROM goals g
	WHERE g.player_id = @player_id
	GROUP BY g.player_id

	RETURN @goals
END

CREATE FUNCTION dbo. fnGetTotalAssistsByPlayer
(
@assist_id AS INT
)
RETURNS INT
AS
BEGIN
	DECLARE @assists AS INT
	SELECT
	@assists = COUNT(assist_id)
	FROM goals g
	WHERE g.assist_id = @assist_id
	GROUP BY g.assist_id

	RETURN @assists
END
;

CREATE FUNCTION dbo. fnGetTotalYellowCardsByPlayer
(
@player_id AS INT
)
RETURNS INT
AS
BEGIN
	DECLARE @yellow_card AS INT
	SELECT
	@yellow_card = COUNT(*)
	FROM cards c
	WHERE c.player_id = @player_id
	AND card_id = 1
	GROUP BY c.player_id

	RETURN @yellow_card
END
;