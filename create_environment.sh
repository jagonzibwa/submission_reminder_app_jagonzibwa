#!/bin/bash
echo -e "What is your name?"
read student_name
mkdirsub="submissions_reminder_$name"
mkdir $mkdirsub
mkdir -p $mkdirsub/{app,models,config,assets}

