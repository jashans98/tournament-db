-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;

-- now connect to the database so we can do stuff
\c tournament

-- assign unique id's with serial, and get a primary key
CREATE TABLE players (
  name text,
  id serial primary key
);

CREATE TABLE matches (
  winner integer references players (id),
  loser integer references players (id)
);

-- helper views: enable creation of summary of matches
CREATE VIEW win_record AS
SELECT id, count(winner) as wins
FROM 
  players LEFT JOIN matches 
  ON players.id = matches.winner
GROUP BY id
ORDER BY wins DESC;

CREATE VIEW lose_record AS
SELECT id, count(loser) as losses
FROM 
  players LEFT JOIN matches 
  ON players.id = matches.loser
GROUP BY id;

-- view to turn matches into summaries
CREATE VIEW summary_record AS
SELECT win_record.id, wins, wins+losses as matches
FROM win_record JOIN lose_record
  ON win_record.id = lose_record.id;

-- combine summary record with names
CREATE VIEW match_record AS
SELECT players.id, name, wins, matches
FROM summary_record JOIN players
  ON players.id = summary_record.id
