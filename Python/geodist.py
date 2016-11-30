"""
Simple script to calculate the "great circle" distance in meters between two
geographic points specified in latitude and longitude.

Expects CSVs in the format:

Quake:
DATE_TIME; LATITUDE; LONGITUDE; MAGNITUDE;

Stations:
STATION1_NAME_ID; LATITUDE1; LONGITUDE1;
STATION2_NAME_ID; LATITUDE2; LONGITUDE2;
STATION3_NAME_ID; LATITUDE3; LONGITUDE3;
STATION4_NAME_ID; LATITUDE4; LONGITUDE4;

A file will be output identical to the stations file, with an additional
column containing distances in km between the station and quake epicenter.
"""
import sys
import os
import csv
from obspy.geodetics.base import gps2dist_azimuth


def help_str():
    result = """
Usage:
    python geodist.py QUAKEFILE STATIONFILE OUTFILE
    python geodist.py -c LAT1 LONG1 LAT2 LONG2
    """
    return result

def error(msg):
    print "ERROR: ", msg
    sys.exit(0)

def checkargs():
    if len(sys.argv) < 2:
        error("Wrong number of input values" + help_str())
    mode = sys.argv[1]
    if mode == '-c':
        if len(sys.argv) != 6:
            error("Wrong number of input values" + help_str())
        try:
            script, mode, lat1, lon1, lat2, lon2 = sys.argv
            float(lat1)
            float(lon1)
            float(lat2)
            float(lon2)
        except ValueError:
            error("Latitude and Longitude inputs must be float values.")
    else:
        if len(sys.argv) != 4:
            error("Wrong number of input values" + help_str())
        script, quakefile, stationfile, destfile = sys.argv
        if not os.path.exists(quakefile):
            error("Quake file not found" + quakefile)
        if not os.path.exists(stationfile):
            error("Station file not found" + stationfile)

checkargs()
mode = sys.argv[1]
if mode == '-c':
    script, mode, lat1, lon1, lat2, lon2 = sys.argv
    lat1 = float(lat1)
    lon1 = float(lon1)
    lat2 = float(lat2)
    lon2 = float(lon2)
    result = gps2dist_azimuth(lat1, lon1, lat2, lon2)
    print (result[0] / 1000.0), "km"
else:
    script, quakefile, stationfile, destfile = sys.argv
    qlat = qlon = None

    with open(quakefile, 'rb') as qf:
        rdr = csv.reader(qf, delimiter=';')
        for row in rdr:
            qlat = float(row[1].strip())
            qlon = float(row[2].strip())


    with open(stationfile, 'rb') as sf:
        rdr = csv.reader(sf, delimiter=';')
        df = open(destfile, 'wb')
        wrt = csv.writer(df, delimiter=';')
        for row in rdr:
            sname = row[0]
            slat = float(row[1].strip())
            slon = float(row[2].strip())
            sdist = gps2dist_azimuth(qlat, qlon, slat, slon)
            sdist = sdist[0] / 1000.0
            wrt.writerow([sname, slat, slon, sdist])
        df.close()

    print "Wrote", destfile
