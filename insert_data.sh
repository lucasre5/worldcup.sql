#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
then
  # Obtener team_id para el ganador
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  # Si no se encuentra, insertar equipo
  if [[ -z $WINNER_ID ]]
  then
    INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
    if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into teams, $WINNER
    fi
    # Obtener nuevo team_id para el ganador
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi

  # Obtener team_id para el oponente
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  # Si no se encuentra, insertar equipo
  if [[ -z $OPPONENT_ID ]]
  then
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
    if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into teams, $OPPONENT
    fi
    # Obtener nuevo team_id para el oponente
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi

  # Imprimir valores de las variables
  echo "YEAR: $YEAR"
  echo "ROUND: $ROUND"
  echo "WINNER_ID: $WINNER_ID"
  echo "OPPONENT_ID: $OPPONENT_ID"
  echo "WINNER_GOALS: $WINNER_GOALS"
  echo "OPPONENT_GOALS: $OPPONENT_GOALS"

  # Verificar que todos los valores sean no vacíos
  if [[ $YEAR != "" && $ROUND != "" && $WINNER_ID != "" && $OPPONENT_ID != "" && $WINNER_GOALS != "" && $OPPONENT_GOALS != "" ]]
  then
    # Insertar datos en la tabla games
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into games, $YEAR $ROUND $WINNER $OPPONENT
    fi
  else
    echo "Hay valores vacíos, no se puede insertar."
  fi
fi
 
done