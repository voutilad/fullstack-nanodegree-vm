#FSND Project 2 - Tournament Results
_Originally forked from [fullstack-nanodegree-vm](https://github.com/udacity/fullstack-nanodegree-vm)._

This project demonstrates creating and updating a data model within a relational database as a persistence layer as well as how to push some logic down to the RDBMS for simplifying app-level logic.

## Requirements

The project was built using the following software and their versions.

* [Virtual Box](http://www.virtualbox.org) - v4.3.28
* [Vagrant](http://www.vagrantup.com) - v1.7.2

### Tip for Initializing the Vagrant Instance

There have been some known issues with Vagrant and the versions of *curl* on some operating systems. Using a preview build of _MacOS X 10.10.4_ required pulling down the box image first and adding it to the local Vagrant environment. You can try pulling the box down manually via a browser or curl and then adding the box before running _vagrant up_ per the Usage instructions.

`````
curl http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-i386-vagrant-disk1.box > ubuntu_trusty32.box

vagrant add ubuntu_trusty32.box ubuntu/trusty32
`````

## Usage

Bring the Vagrant managed VM online
`````
vagrant up
`````

Connect to the system via SSH
`````
vagrant ssh
`````

Change to the directory within the VM that's mapped to our project files.
`````
cd /vagrant
`````

First, bootstrap the Tournament PostgreSQL database using the provided SQL script.
`````
psql -f tournament.sql
`````

Run the test Python script that manipulates the state of the tournament within the database and validates Swiss Pairings.
`````
python tournament_test.sql
`````

If everything works, you should see valid output resembling:
`````
1. Old matches can be deleted.
2. Player records can be deleted.
3. After deleting, countPlayers() returns zero.
Adding player "Chandra Nalaar"
4. After registering a player, countPlayers() returns 1.
Adding player "Markov Chaney"
Adding player "Joe Malik"
Adding player "Mao Tsu-hsi"
Adding player "Atlanta Hope"
5. Players can be registered and deleted.
Adding player "Melpomene Murray"
Adding player "Randy Schwartz"
6. Newly registered players appear in the standings with no matches.
Adding player "Bruno Walton"
Adding player "Boots O'Neal"
Adding player "Cathy Burton"
Adding player "Diane Grant"
7. After a match, players have updated standings.
Adding player "Twilight Sparkle"
Adding player "Fluttershy"
Adding player "Applejack"
Adding player "Pinkie Pie"
8. After one match, players with one win are paired.
Success!  All tests pass!
`````

## References
In identifying the approach for creating the Standings and Swiss Pairings, I consulted a few sources.

* TODO: link to PostgreSQL doc
* http://stackoverflow.com/questions/3397121/how-to-show-row-numbers-in-postgresql-query
