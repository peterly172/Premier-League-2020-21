CREATE TABLE teams ( 
id INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
team_short_name VARCHAR(3), 
name VARCHAR(100), 
coach VARCHAR(100)
); 

CREATE TABLE venues ( 
id INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
name VARCHAR(50), 
city VARCHAR (50), 
capacity INT 
); 

CREATE TABLE players (
id INT NOT NULL PRIMARY KEY,
name VARCHAR(100),
position_id INT,
team_id INT
	);

CREATE TABLE positions (
id INT IDENTITY(1,1) PRIMARY KEY,
name VARCHAR(20)
	);


CREATE TABLE gameweek ( 
id INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
name VARCHAR(15), 
start_date DATE, 
end_date DATE 
) ; 


CREATE TABLE match ( 
id INT NOT NULL PRIMARY KEY, 
date DATE, 
time TIME, 
gameweek_id INT, 
venue_id INT, 
hometeam_id INT, 
awayteam_id INT
 
); 

CREATE TABLE scores ( 
match_id INT NOT NULL PRIMARY KEY, 
gameweek_id INT, 
venue_id INT, 
hometeam_id INT, 
awayteam_id INT, 
hometeam_goal NUMERIC, 
awayteam_goal NUMERIC 

); 

CREATE TABLE goals (
id INT IDENTITY(1,1) PRIMARY KEY,
match_id INT,
player_id INT,
team_id INT, 
goal_time INT,
goal_half INT,
assist_id INT
) ;

CREATE TABLE cards (
id INT IDENTITY(1,1) PRIMARY KEY,
match_id INT,
player_id INT,
team_id INT,
card_id INT,
card_time INT
);

CREATE TABLE colour(
id INT IDENTITY(1,1) PRIMARY KEY,
card VARCHAR(10)
);
