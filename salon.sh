#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

#$($PSQL "SELECT * FROM table")

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "Welcome to My Salon, how can I help you?\n"
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES" | while read  SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED

  
  if [[ $SERVICE_ID_SELECTED =~ ^[1-5]$ ]]
  then
    MAKE_APPOINTMENT
  else
    MAIN_MENU "I could not find that service. What would you like today?"
  fi
}

MAKE_APPOINTMENT(){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    #No esta el phone registrado hay que registrarlo
    echo -e 'Phone number not registred, whats your name'
    read CUSTOMER_NAME
    ($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  fi
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  #Llegue aca con el usuario ya registrado si o si.
  echo -e "Hello $CUSTOMER_NAME, what's your service time"
  read SERVICE_TIME
  

  #TENGO todo hago al appointment
  ($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ('$CUSTOMER_ID','$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."


}



MAIN_MENU