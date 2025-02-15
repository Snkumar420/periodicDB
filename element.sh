#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi
ELEMENT=$1
if [[ $ELEMENT =~ ^[0-9]+$ ]]
then
  QUERY="SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
         FROM elements 
         JOIN properties ON elements.atomic_number = properties.atomic_number 
         JOIN types ON properties.type_id = types.type_id 
         WHERE elements.atomic_number = $ELEMENT"
else
  QUERY="SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
         FROM elements 
         JOIN properties ON elements.atomic_number = properties.atomic_number 
         JOIN types ON properties.type_id = types.type_id 
         WHERE symbol = '$ELEMENT' OR name = '$ELEMENT'"
fi

RESULT=$($PSQL "$QUERY")

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
else
  echo "$RESULT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  done
fi
