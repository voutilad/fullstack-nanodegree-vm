-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

CREATE DATABASE tournament;
\c tournament;

CREATE TABLE player (
  id  int primary key not null,
  name  text  not null,
);

CREATE TABLE tournament (
  id  int primary key not null,
  date  date DEFAULT CURRENT_DATE,
  name  text
)

CREATE TABLE match (
  id  int primary key not null,
  home_player_id  int references player(id),
  away_player_id  int references player(id),
  home_score  int DEFAULT 0,
  away_score  int DEFAULT 0,
  winner  int references player(id),
  round int,
  tournament_id int references tournament(id),
)
