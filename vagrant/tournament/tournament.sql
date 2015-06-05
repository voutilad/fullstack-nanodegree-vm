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

\echo Creating Tournament Table...
CREATE TABLE tournament (
  id  SERIAL PRIMARY KEY NOT NULL,
  date  date DEFAULT CURRENT_DATE,
  name  text
);

\echo Creating Match Table...
CREATE TABLE match (
  id  SERIAL PRIMARY KEY NOT NULL,
  home_score  int DEFAULT 0,
  away_score  int DEFAULT 0,
  winner  int REFERENCES player(id),
  loser int REFERENCES player(id),
  round int,
  tournament_id int REFERENCES tournament(id)
);
