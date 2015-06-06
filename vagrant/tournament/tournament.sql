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

\echo Creating Standings View
CREATE VIEW standings 
AS
  SELECT p.id, p.name, count(w.winner) AS wins, count(w.id) + count(l.id) as matches FROM
   player p FULL OUTER JOIN
    match w on p.id = w.winner
   FULL OUTER JOIN
    match l on p.id = l.loser
  GROUP BY p.id
  ORDER BY wins DESC;
