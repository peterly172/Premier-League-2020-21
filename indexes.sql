CREATE Clustered Index IX_earliest_goals
ON goals (goal_time ASC)

CREATE Clustered Index IX_scores_venue
ON scores (venue_id ASC)

CREATE Clustered Index IX_earliest_card
ON cards (card_time ASC)

CREATE Clustered Index IX_player_names
ON players (name ASC)