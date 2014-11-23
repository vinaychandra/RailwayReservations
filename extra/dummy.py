 #!/usr/bin/python

from helpers import *
import psycopg2,sys
flush = sys.stdout.flush

print "Connecting Database...",
flush()
conn = psycopg2.connect(database="cs387", user="vinaychandra", password="admin123", host="127.0.0.1", port="5432")
print "Done"
cursor = conn.cursor()

print "Resetting the database...",
flush()
import os
os.system("psql -d cs387 -f create.sql > /dev/null")
print "Done"

print "Creating Stations...",
flush()
station_sql = create_stations()
cursor.execute(station_sql[0],station_sql[1])
print "Done"

print "Creating fare table...",
flush()
fare_sql_list = create_fares()
for sql in fare_sql_list:
	cursor.execute(sql[0],sql[1])
	pass
print "Done"

print "Creating trains and routes...",
flush()
routes_sql_list = create_trains()
for sql in routes_sql_list:
	cursor.execute(sql[0],sql[1])
	pass
print "Done"

print "Creating users...",
flush()
users_sql = create_users()
cursor.execute(users_sql[0],users_sql[1])
print "Done"

print "Creating availability...",
flush()
avail_sql = create_availability()
for sql in avail_sql:
	cursor.execute(sql[0],sql[1])
print "Done"

print "Creating tickets..."
ticket_sql,person_sql,avail_sql = create_tickets()
print "Ready to adjust database"
print "\tPopulating tickets...",
flush()
for sql in ticket_sql:
	cursor.execute(sql[0],sql[1])
print "Done"
print "\tPopulating travellers...",
flush()
for sql in person_sql:
	cursor.execute(sql[0],sql[1])
print "Done"
print "\tAdjusting availability table...",
flush()
for sql in avail_sql:
	try:
		cursor.execute(sql[0],sql[1])
	except Exception:
		pass
print "Done"

print "Closing database...",
flush()
conn.commit()
cursor.close()
conn.close()
print "Done"

# import code; code.interact(local=locals())
print "Run Successful"