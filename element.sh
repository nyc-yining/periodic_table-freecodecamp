#! /bin/bash
PSQL="psql -X --username=freecodecamp dbname=periodic_table --tuples-only -c"
# "\n~~~~~ periodic_table database ~~~~~\n"

getPeriodic(){
  if [[ -z $1 ]]
  then 
    echo "Please provide an element as an argument."
  else
    PRINT_ELEMENT $1
  fi
}

PRINT_ELEMENT(){
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      ELEMENT_NUMBER=$($PSQL "select atomic_number from elements where atomic_number=$1" | sed 's/ //g')
    else
      ELEMENT_NUMBER=$($PSQL "select atomic_number from elements where symbol='$1' or name='$1'" | sed 's/ //g')
    fi

    if [[ -z $ELEMENT_NUMBER ]]
    then
      echo "I could not find that element in the database."
    else
      NAME=$($PSQL "select name from elements where atomic_number=$ELEMENT_NUMBER" | sed 's/ //g')
      SYMBOL=$($PSQL "select symbol from elements where atomic_number=$ELEMENT_NUMBER" | sed 's/ //g')
      TYPE_ID=$($PSQL "select type_id from properties where atomic_number=$ELEMENT_NUMBER" | sed 's/ //g')
      ATOMIC_MASS=$($PSQL "select atomic_mass from properties where atomic_number=$ELEMENT_NUMBER" | sed 's/ //g')
      MELTING_POINT_CELSIUS=$($PSQL "select melting_point_celsius from properties where atomic_number=$ELEMENT_NUMBER" | sed 's/ //g')
      BOILDING_POINT_CELSIUS=$($PSQL "select boiling_point_celsius from properties where atomic_number=$ELEMENT_NUMBER" | sed 's/ //g')
      TYPE=$($PSQL "select type from types left join properties on properties.type_id=types.type_id where atomic_number=$ELEMENT_NUMBER" | sed 's/ //g')
      echo "The element with atomic number $ELEMENT_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILDING_POINT_CELSIUS celsius."
    fi
}

getPeriodic $1