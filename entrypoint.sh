#!/bin/bash

service nginx start
service php5-fpm start
service supervisor start
service sshd start

/bin/bash
