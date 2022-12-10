#!/bin/bash
##PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"
RNUM=$(( $RANDOM % 1000 + 1 ))

echo -n "Enter your username: "
read USERNAME

USERINFO=$($PSQL "SELECT bestGame, gameCount FROM users WHERE userName = '$USERNAME'")
if [[ -z $USERINFO ]]
then
	echo "Welcome, $USERNAME! It looks like this is your first time here."
	USERINSERT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
else
	read BESTGAME BAR GAMECOUNT  < <(echo $USERINFO)
	echo "Welcome back, $USERNAME! You have played $GAMECOUNT games, and your best game took $BESTGAME guesses."
fi
echo "Guess the secret number between 1 and 1000:"
read guess
