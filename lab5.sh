#!/bin/bash

LANG=en_US.UTF-8

# Función para mostrar resultados con color
show_result() {
  local status=$1
  local message=$2
  local GREEN='\033[0;32m'
  local RED='\033[0;31m'
  local NC='\033[0m' # No color

  if [ $status -eq 0 ]; then
    echo -e "${message} [${GREEN}OK${NC}]"
  else
    echo -e "${message} [${RED}FAILED${NC}]"
  fi
}

function replica() {
  ipa server-find
  ipa-replica-manage list
}

function accounts() {

if [ -z "$1" ]; then
  echo "SYNTAX: $0 accounts all|group_name"
  exit 2
fi

if [ "$1" = "all" ]; then
  groups="psiadmins netadmins devops it"
else
  groups="$1"
fi

echo "**************************"
echo "Accounts and Groups"
echo "**************************"
for group in ${groups}; do
  echo "${group}"
  echo "++++++++++++++++++++++"
  ipa group-show ${group} >/dev/null 2>&1
  show_result $? "Exists ${group}"
  
  members=$(ipa group-show ${group} 2>/dev/null | grep 'Member users:' | cut -d: -f2 | tr -d ",") 
  members_managers=$(ipa group-show ${group} 2>/dev/null | grep 'Membership managed by' | cut -d: -f2 | tr -d ",") 

  if [ ! -z "${members}" ]; then
    echo "Members Info"
    for member in ${members}; do
      shell=$(ipa user-show ${member} 2>/dev/null | grep -i 'Login shell' | cut -d: -f2 | xargs)
      echo "==> ${member} - ${shell}"
    done
  else
    echo "No members"
    show_result 1 "Members ${group}"
  fi

  if [ ! -z "${members_managers}" ]; then
    echo "Members Managers"
    for manager in ${members_managers}; do
      echo "==> ${manager}"
    done
  else
    echo "No managers"
    show_result 1 "Managers ${group}"
  fi
done

}

function lab() {

echo "**************************"
echo "LABs specific Users"
echo "**************************"

echo "Get employees numbers"
echo "1001"
ipa user-find --employeenumber=1001
echo "1002"
ipa user-find --employeenumber=1002

echo "psi02 - preserved"
preserved=$(ipa user-show psi02 2>/dev/null | grep -i preserved | xargs)
if [ -n "$preserved" ]; then
  echo "==> $preserved"
  show_result 0 "Preserved psi02"
else
  show_result 1 "Preserved psi02"
fi

echo "psi01 - expiration"
expiration=$(ipa user-show psi01 --all 2>/dev/null | grep -i expiration | xargs)
if [ -n "$expiration" ]; then
  echo "==> $expiration"
  show_result 0 "Expiration psi01"
else
  show_result 1 "Expiration psi01"
fi

echo "Get users from Guatemala in psiadmins"
ipa user-find --in-groups=psiadmins --city=Guatemala

echo "**************************"
echo "Password Policies"
echo "**************************"
ipa pwpolicy-find
}

case "$1" in
  "lab")
    lab
    ;;
  "accounts")
    accounts "$2"
    ;;
  "replica")
    replica
    ;;
  *)
    echo "Uso: $0 lab|accounts|replica"
    ;;
esac
