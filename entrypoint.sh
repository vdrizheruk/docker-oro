#!/bin/bash

service nginx start
service php5-fpm start
service supervisor start
service ssh start

/bin/bash
