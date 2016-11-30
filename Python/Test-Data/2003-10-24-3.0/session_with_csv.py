# coding: utf-8

import obspy
st2 = obspy.read("2003-11-10_M_3.0/Package_1480501822584-KNMI_8135_KNMI.mseed")
st2
tr1 = st2[0]
tr2 = st2[1]
from obspy.geodetics.base import gps2dist_azimuth
tr1.stats
st2
tr1.stats.location
# Great, so the mseed data from the KNMI web interface has no location data! :-O
import csv
csv.list_dialects()
fp = open('testquake.csv', 'wb')
writer = csv.writer(fp, delimiter='; ')
writer = csv.writer(fp, delimiter=';')
writer.writerow([53.23, 6.83])
fp.close()
get_ipython().magic(u'ls ')
get_ipython().magic(u'cat testquake.csv')
with open('teststations.csv', 'wb') as fp:
    writer = csv.writer(fp, delimiter=';')
    writer.writerow([53.41, 6.48])
    writer.writerow([52.89, 6.63])
    
get_ipython().magic(u'ls ')
get_ipython().magic(u'cat teststations.csv')
gps2dist_azimuth(53.23, 6.83, 53.41, 6.48)
gps2dist_azimuth(53.23, 6.83, 52.89, 6.63)
get_ipython().magic(u'ls ')
get_ipython().magic(u'cd ../../')
get_ipython().magic(u'cd ../Drive/DEV/earthquake-archive/')
get_ipython().magic(u'ls ')
get_ipython().magic(u'cd Python/')
get_ipython().magic(u'ls ')
get_ipython().magic(u'cd test-data/')
get_ipython().magic(u'ls ')
get_ipython().magic(u'cd 2003-10-24-3.0/')
get_ipython().magic(u'ls ')
qf = open('quake_info.csv', 'rb')
sf = open('station_info.csv', 'rb')
df = open('distance_info.csv', 'wb')
qreader = csv.reader(qf, delimiter=';')
qreader
for row in qreader:
    print row
    
" blah blah ".strip()
for row in qreader:
    print row
    
float("+53.40")
qf.close()
rdr = csv.reader(sf, delimiter=';')
for row in rdr:
    print row
    
sf.close()
df.close()
get_ipython().magic(u'save session_with_csv.py')
get_ipython().magic(u'save session_with_csv 0-50')
