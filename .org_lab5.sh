#!/bin/bash

LANG=en_US.UTF-8

function replica() {
  ipa server-find
  ipa-replica-manage list
}

function accounts() {

if [ -z $1 ]
then
 echo "SYNTAX: $0 $1 accounts all|group_name"
 exit 2
fi
if [ "$1" = "all" ]
then
 groups="psiadmins netadmins devops it"
else
 groups="$1"
fi

echo "**************************"
echo "Accounts and Groups"
echo "**************************"
for group in ${groups}
do
 echo "${group}"
 echo "++++++++++++++++++++++"
 ipa group-show ${group}
 if [ $? -eq 0 ]
 then
   echo "Exists ${group} = OK"
 else
   echo "Exists ${group} = FAILED"
 fi
 members=$(ipa group-show ${group}|grep 'Member users:'|cut -d: -f2|tr -d ",") 
 members_managers=$(ipa group-show ${group}|grep 'Membership managed by'|cut -d: -f2|tr -d ",") 
 #echo "${members}"
 if [ ! -z "${members}" ]
 then
  echo "Members Info"
  for member in ${members}
  do
   echo "==> ${member} - $(ipa user-show ${member}|grep -i 'Login shell'|cut -d: -f2|xargs)"
  done
 else
  echo "No members"
  echo "Members ${group} = FAILED"
 fi   
 if [ ! -z "${members_managers}" ]
 then
  echo "Members Managers"
  for manager in ${members_managers}
  do
   echo "==> ${manager} "
  done
 else
  echo "No managers"
  echo "Managers ${group} = FAILED"
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
echo "==> $(ipa user-show psi02|grep -i preserved |xargs)"

echo "psi01 - expiration"
echo "==> $(ipa user-show psi01 --all|grep -i expiration|xargs)"


echo "Get users from Guatemala in psiadmins"
ipa user-find --in-groups=psiadmins  --city=Guatemala

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
 accounts $2
 ;;
 "replica")
 replica
 ;;
 *)
 echo "Uso: $0 lab|accounts|replica"
 ;;
esac
