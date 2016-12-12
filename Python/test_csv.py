import csv

quake_info = {}

with open( 'Test-Data/2015-09-30-3.1/quake_info.csv', 'rb'  ) as csvfile:
    reader = csv.reader( csvfile, delimiter=';', quotechar = '|' )
    for row in reader:
        print ', '.join(row)
        print float( row[1] )
        
        quake_info = { 'time': row[0], 'longitude': float( row[1] ), 'latitude': float( row[2] ), 'magnitude': float( row[3] ) }
        
station_info = {}

with open( 'Test-Data/2015-09-30-3.1/distance_info.csv', 'rb'  ) as csvfile:
    reader = csv.reader( csvfile, delimiter=';', quotechar = '|' )
    for row in reader:
        #print row[0].split( ' ' )
        statid = row[0].split( ' ' )[1]
        #print statid
        station_info[ statid ] = { 'latitude': float( row[1] ), 'longitude': float( row[2] ), 'distance': float( row[3] ) }
        #print station_info[ statid ]

print quake_info
print station_info