# This file primarily returns the sql commands or the supersets of it
from sql import *
from sql.aggregate import *
from sql.conditionals import *
from faker import Factory
from itertools import *

from random import *
from datetime import *

fake = Factory.create()

NUMBER_OF_TRAINS= 50
RESERVED_FOR_DAYS = 30
NUMBER_OF_USERS = 10000
NUMBER_OF_STATIONS = 200
#Note that total number of journeys = reserved_for_days*number_of_trains

#Variable for this session...
station_list = None
data_station_codes = []
list_routes = []
data_stations = []
usernames = []

def calculate_age(born):
    today = date.today()
    return today.year - born.year - ((today.month, today.day) < (born.month, born.day))

def create_stations():
	global data_station_codes
	global data_stations
	global station_list

	for i in range(NUMBER_OF_STATIONS):
		data_stations.append(fake.city())

	# A helper function
	def sc(city):
		lis = list(combinations(city,3))
		for val in lis:
			combination = ""
			for z in val: combination+=z
			combination = combination.strip().upper()
			if combination not in data_station_codes:
				data_station_codes.append(combination)
				return combination
		lis = list(combinations(city,4))
		for val in lis:
			combination = ""
			for z in val: combination+=z
			combination = combination.strip().upper()
			if combination not in data_station_codes:
				data_station_codes.append(combination)
				return combination
		raise Exception("Cannot create the code for the city...")

	station_list = [[sc(x).encode('ascii','ignore'),x.encode('ascii','ignore')] for x in data_stations]
	data_station_codes = [x.encode('ascii','ignore') for x in data_station_codes]

	station = Table('station')
	return tuple(station.insert(values=station_list))

def create_fares():
	all_pairs_of_stations = list(combinations(station_list,2))
	return_list = []
	fare_table = Table('faretable')

	for each_pair in all_pairs_of_stations:
		station_id1 = each_pair[0][0]
		station_id2 = each_pair[1][0]
		fare = randrange(300,1500)
		return_list.append(tuple(fare_table.insert(values=[[station_id1,station_id2,fare]])))
		return_list.append(tuple(fare_table.insert(values=[[station_id2,station_id1,fare]])))
	return return_list

def create_trains():
	global list_routes
	return_list = []
	for train_number in range(1,1+NUMBER_OF_TRAINS):
		route = sample(data_station_codes,randrange(2,20))

		#The train table
		train = Table('train')
		return_list.append(tuple(train.insert(values=[[train_number,route[0],route[-1],'name']])))
		list_routes.append([train_number,route])

		#The route table
		table = Table('route')
		for ith_station in range(len(route)):
			return_list.append(tuple(table.insert(\
				values=[[train_number, route[ith_station], ith_station+1, '00:00', '00:00']])))
	return return_list

def create_users():
	return_list=[]
	table = Table('users')
	
	full_list = [[fake.user_name().encode('ascii','ignore'),\
	fake.name().encode('ascii','ignore'),\
	fake.password().encode('ascii','ignore')]	for i in range(NUMBER_OF_USERS)]
	cleaned = dict((x[0], x) for x in full_list).values()
	global usernames 
	usernames = [x[0] for x in cleaned]
	return tuple(table.insert(values=cleaned))

def create_availability():
	return_list = []
	table = Table('availability')
	global list_routes
	for i in list_routes:
		train = i[0]
		route = i[1]

		start_date = date.today()
		for single_date in (start_date + timedelta(n) for n in range(RESERVED_FOR_DAYS)):
			return_list.append(tuple(table.insert(columns=[table.station,table.seats,table.train,table.travel_date], values=[[place,100,train,str(single_date)] for place in route[1:]])))
	return return_list

def create_tickets():
	ticket_sql = []
	person_sql = []
	avail_sql = []
	person_table = Table('person')
	ticket_table = Table('ticket')
	avail_table  = Table('availability')

	for user in usernames:
		for single_date in (start_date + timedelta(n) for n in range(RESERVED_FOR_DAYS)):
			if randrange(10) < 4 :
				train = choice(list_routes)
				src,dst = choice(list(combinations(train[1],2)))
				ticket_sql.append(tuple(ticket_table.insert(columns=[\
					ticket_table.journey_train,ticket_table.journey_date,ticket_table.src,ticket_table.dest,ticket_table.user],\
					values=[train[0],single_date,src,dst,user])))
				route_for_user = train[1][train[1].index(src)+1:train[1].index(dst)+1]
				for stop in route_for_user:
					avail_sql.append(tuple(avail_table.update(columns=\
						[avail_table.station,avail_table.seats,avail_table.journey_train,avail_table.journey_date],\
						values=[])))
