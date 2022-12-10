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
	BESTGAME=0
	GAMECOUNT=0
else
	read BESTGAME BAR GAMECOUNT  < <(echo $USERINFO)
	echo "Welcome back, $USERNAME! You have played $GAMECOUNT games, and your best game took $BESTGAME guesses."
fi

echo "Guess the secret number between 1 and 1000:"
read GUESS
PLAYING=1
CNT=1
while (( $PLAYING == 1 ))
do
	if (( $GUESS == $RNUM ))
	then
		echo "You guessed it in $CNT tries. The secret number was $RNUM. Nice job!"
		PLAYING=0

		if ((  $BESTGAME == 0  ))
		then
			BESTGAME=$CNT
		fi
		if (( $CNT < $BESTGAME ))
		then
			BESTGAME=$CNT
		fi
	        USERUPDATE=$($PSQL "UPDATE users
		                    SET gameCount = gameCount+1,
				        bestGame  = '$BESTGAME' 
		                    WHERE userName = '$USERNAME'")
	elif (( $RNUM > $GUESS ))
	then
		echo "It's higher than that, guess again:"	
	elif (( $RNUM < $GUESS ))
	then
		echo "It's lower than that, guess again:"	
	fi	

	if (( $PLAYING == 1 ))
	then
		read GUESS
		let CNT++
	fi
done
