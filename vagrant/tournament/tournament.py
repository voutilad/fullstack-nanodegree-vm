#!/usr/bin/env python
#
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2

# Delete all match data
__DELETE_MATCHES = 'DELETE FROM match;'
# Delete all player data
__DELETE_PLAYERS = 'DELETE FROM player;'
# Register a new player
__ADD_PLAYER = 'INSERT INTO player VALUES (DEFAULT, %s);'
# Counts players
__COUNT_PLAYERS = 'SELECT count(*) FROM player'
# Add match results
__ADD_MATCH = 'INSERT INTO match VALUES (DEFAULT, %s, %s)'

# Get standings
__STANDINGS = """
    SELECT p.id, p.name, count(w.winner) AS wins, count(w.id) + count(l.id) as matches FROM
     player p FULL OUTER JOIN
      match w on p.id = w.winner
     FULL OUTER JOIN
      match l on p.id = l.loser
    GROUP BY p.id;
    """

"""
Global reference to a private connection so we can re-use one across
many function calls to connect()
"""
__conn = None

def __execute(connection, sql, data=None, commit=True, fetchSize=10):
    """ Private execution method for sending data via SQL.

    Args:
        connection (object) - psycopg2.connection instance
        sql (string) - SQL statement to execute
        data (tuple) - psycopg2-friendly tuple
            (see http://initd.org/psycopg/docs/usage.html#the-problem-with-the-query-parameters)
        commit (boolean) - whether or not to commit the transaction
        fetchSize (int) - number of result rows to fetch

    Returns:
        Result of the cursor.fetchone() call...so a tuple of the first result?
    """
    cur = connection.cursor()
    if data is None:
        data = ()

    try:
        cur.execute(sql, data)
        if commit:
            connection.commit()
        result = cur.fetchmany(fetchSize)
    except psycopg2.InternalError:
        # Something is amiss.
        print '[caught internal error]'
        result = [()]

    except psycopg2.ProgrammingError:
        # No rows
        result = [()]
    finally:
        cur.close()

    return result

def connect():
    """Connect to the PostgreSQL database.  Returns a database connection."""
    global __conn

    if __conn is None or __conn.closed == 1:
        __conn = psycopg2.connect('dbname=tournament')

    return __conn

def deleteMatches():
    """Remove all the match records from the database."""
    __execute(connect(), __DELETE_MATCHES, commit=True)

def deletePlayers():
    """Remove all the player records from the database."""
    __execute(connect(), __DELETE_PLAYERS, commit=True)


def countPlayers():
    """Returns the number of players currently registered."""
    result = __execute(connect(), __COUNT_PLAYERS)
    if result and len(result[0]) > 0:
        return result[0][0]
    else:
        return -1

def registerPlayer(name):
    """Adds a player to the tournament database.

    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)

    Args:
      name: the player's full name (need not be unique).
    """
    print 'Adding player "' + str(name) + '"'
    __execute(connect(), __ADD_PLAYER, data=(name,), commit=True)


def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """
    return __execute(connect(), __STANDINGS, fetchSize=100)


def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """
    __execute(connect(), __ADD_MATCH, data=(winner, loser), commit=True)

def swissPairings():
    """Returns a list of pairs of players for the next round of a match.

    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.

    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
