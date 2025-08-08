#!/bin/bash

quicklaunch_documents(){
    path="$HOME/purgatory/notes/documents/"
    cd "$path"
    if [ "$#" -gt 0 ]; then
    "$@"
    fi
}
quicklaunch_projects(){
    path="$HOME/init-strange/projects/playground"
    cd "$path"
    if [ "$#" -gt 0 ]; then
    "$@"
    fi
}
quicklaunch_notes(){
    path="$HOME/purgatory/notes/my_notes"
    cd "$path"
    if [ "$#" -gt 0 ]; then
    "$@"
    fi
}
quicklaunch_config(){
    path="$HOME/.config"
    cd "$path"
    if [ "$#" -gt 0 ]; then
    "$@"
    fi
}

alias configs='quicklaunch_config'
alias config='quicklaunch_config'

alias projects='quicklaunch_projects'
alias project='quicklaunch_projects'
alias proj='quicklaunch_projects'

alias documents='quicklaunch_documents'
alias docu='quicklaunch_documents'

alias note='quicklaunch_notes'
alias notes='quicklaunch_notes'
