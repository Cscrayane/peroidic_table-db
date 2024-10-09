if [[ $1 ]]
then
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    QUERY=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
  else
    QUERY=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$1' OR symbol = '$1'")
  fi
  if [[ -z $QUERY ]]
  then
    echo "I could not find that element in the database."
  else
    echo $QUERY | while IFS="|" read A N S T M MP BP
    do
      echo "The element with atomic number $A is $N ($S). It's a $T, with a mass of $M amu. $N has a melting point of $MP celsius and a boiling point of $BP celsius."
    done 
  fi
else
  echo Please provide an element as an argument.
fi