-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

\echo Creating database...
CREATE DATABASE tournament;
\c tournament;

\echo Creating Player Table...
CREATE TABLE player (
  id SERIAL PRIMARY KEY NOT NULL,
  name  text  not null
);

\echo Creating Match Table...
CREATE TABLE match (
  id  SERIAL PRIMARY KEY NOT NULL,
  winner  int REFERENCES player(id),
  loser int REFERENCES player(id)
);

/*
   Standings View
   --------------
   Provides current standings for all players regardless of if they've played
   any matches and sorts by wins.
   
 */
\echo Creating Standings View
CREATE VIEW standings
AS
  SELECT p.id, p.name, count(w.winner) AS wins, count(w.id) + count(l.id) AS matches
  FROM player p
  FULL OUTER JOIN
    match w on p.id = w.winner
   FULL OUTER JOIN
    match l on p.id = l.loser
  GROUP BY p.id
  ORDER BY wins DESC;

/*
  Swiss Pairings View
  --------------------
  Leverages the standings view to match players to those near each other in the standings.

  Relies on PostgreSQL's row_number() function and properties of player id's being
  incrementing integers that are unique.
 */
\echo Creating Pairings view based on Standings view
CREATE VIEW pairings
AS
  SELECT p1.id AS player1_id, p1.name AS player1_name, p2.id AS player2_id, p2.name AS player2_name FROM
    (SELECT (row_number() over() - 1) / 2 AS pairing, id, name FROM standings) p1
  JOIN
    (SELECT (row_number() over() - 1) / 2 AS pairing, id, name FROM standings) p2
  ON p1.pairing = p2.pairing WHERE p1.id != p2.id AND p1.id > p2.id;
