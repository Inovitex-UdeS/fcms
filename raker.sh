#!/bin/sh
rake db:drop && rake db:create && rake db:schema:load && rake db:migrate && rake db:seed
