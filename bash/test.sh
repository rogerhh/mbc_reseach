#!/bin/bash

sqlite3 ~/mbc_research/data/mbc_database.db

select * from SENSOR_DATA;
