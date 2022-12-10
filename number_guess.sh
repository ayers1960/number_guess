#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

RNUM=$(( $RANDOM % 1000 + 1 ))

echo -n "Enter your username: "
read USERNAME

USERINFO=$($PSQL "SELECT bestGame, gameCount FROM users WHERE userName = '$USERNAME'")
echo $USERINFO
if [[ -z $USERINFO ]]
then
	echo "Welcome, $USERNAME! It looks like this is your first time here."
	USERINSERT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
fi
echo "Guess the secret number between 1 and 1000:"
read guess
