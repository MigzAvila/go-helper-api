#!/bin/bash

SIMPLE_GO_CODE="// File: cmd/api/main.go\n package main \nimport \"fmt\" \nfunc main() { \nfmt.Println(\"Starting Server....\")\n}"

function debugger() {
  # Simple dubugger function to avoid writing mutiple echo in the project
  # debugger gets two params,
  # 1 -> the actual msg to be display,
  # 2 -> if the msg is an error or msg to ask/notify the user about something important
  local message=$1
  local is_error_type=${2:-false}


  if [ "$is_error_type" = true ]
  then
      echo -e "\033[0;31m[ERROR]\n$message"
  else
      echo -e "\033[0;33m$message\033[0m"
  fi

}

function create_directory_with_go_code(){
   # Function that will create a go api structure
   local root_directory=$1
   local identifier=$2

   mkdir -p $root_directory
   cd $root_directory

   mkdir -p bin cmd/api internals migrations remote
   echo -e $SIMPLE_GO_CODE >> cmd/api/main.go
   touch Makefile
   go mod init $root_directory.$identifier 
   debugger "\n\nI have created a *main.go* file for you to test the directory structure.\nType \033[0;36m*go run ./cmd/api*\033[0;33m at the root directory of your project to test your project.\nThank you."
}

function create_go_api_structure() {
  # Function that will verify that the user want to create the go api structure
  local root_directory=$1
  local identifier=$2

  debugger "\nI am about to create a directory structure named *$root_directory*.\nDo you want me to continue? [Yes/no]" 
  read user_authorization

  if [ $user_authorization = "Yes" ]
  then 
     debugger "\n\nCreate directory structure..."
     create_directory_with_go_code $root_directory $identifier
  elif [ $user_authorization = "no" ]
  then
     debugger "Abort" true
  else 
     debugger "You passed an invalid command. Valid commands [Yes/no]" true
  fi

}

function make-go-dir() {
  # Main function that will call subfunction/utility function to do all the work
  # Save Variable pass by the use in the console
  # Require two variables
  local root_directory=$1
  local identifier=$2

  if [ -z "$root_directory" ] || [ -z "$identifier" ]
  then
      debugger "You need to provide two arguments for this script to work.\nUsage: make-go-dir <root directory name> <identifier name>" true
  else
     create_go_api_structure $root_directory $identifier 
  fi


}

