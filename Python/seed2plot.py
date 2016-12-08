import sys
import os
import obspy
from PIL import Image as PIL_Image

from obspy.geodetics.base import gps2dist_azimuth

# Make a file with lat & long for stations & for earthquakes
# Can be done from the streams?
# Options for visual plots for each earthquake
# Earthquake magnitude / Location of earthquake & stations
# Plot of three signals per station

# Time window to plot (in seconds around event origin time)
pre_offset = 0
post_offset = 40

import csv

quake_info = {}
station_info = {}

distance_offset = { 'HHE': 500, 'HHZ': 0, 'HHN': -500 }
#distance_offset = { 'HHE': 0.5, 'HHZ': 0, 'HHN': -0.5 }


def read_quake_info( filename ):
    global quake_info
    with open( filename, 'rb'  ) as csvfile:
        reader = csv.reader( csvfile, delimiter=';', quotechar = '|' )
        for row in reader:
            quake_info = { 'time': row[0], 'longitude': float( row[2] ), 'latitude': float( row[1] ), 'magnitude': float( row[3] ) }
        
def read_station_info( filename ):
    global station_info
    with open( filename, 'rb'  ) as csvfile:
        reader = csv.reader( csvfile, delimiter=';', quotechar = '|' )
        for row in reader:
            statid = row[0].split( ' ' )[1]
            station_info[ statid ] = { 'latitude': float( row[1] ), 'longitude': float( row[2] ) }
            #station_info[ statid ] = { 'latitude': float( row[1] ), 'longitude': float( row[2] ), 'distance': float( row[3] ) }

def help_str():
    result = """
        Usage: python seed2plot.py FILE_NAME QUAKE_INFO STATION_INFO DEST_DIRECTORY
            FILE_NAME:      mseed file to load
            QUAKE_INFO:     quake info file to load
            STATION_INFO:   station info file to load
            DEST_DIRECTORY: file to save image to
    """
    return result

def error(msg):
    print "ERROR:", msg
    sys.exit(0)

#def checkargs():
    #if len(sys.argv) < 4:
        #error("Wrong number of input values" + help_str())
    ##script, srate, fname, destdir = sys.argv
    #try:
        #int(srate)
    #except ValueError:
        #if srate != 'native':
            #error("Sample rate must be an integer value or native for native sampling rate.")


#def plottrace(trace, sr, dest):
    #eventtime = trace.stats.starttime.strftime("%Y-%m-%d_%H-%M-%S_")
    #stationcode = "%s_%s_%s" % (trace.stats.network, trace.stats.station, trace.stats.channel)
    
    #if sr == 'native':
        #sr = tr.stats.sampling_rate
    #tr.write(path, format='WAV', framerate=sr)
    #print "Writing", path


# TODOS:
# Add option to force sample rate or use original
# Make a file with lat & long for stations & for earthquakes
# Can be done from the streams?
# Options for visual plots for each earthquake
# Earthquake magnitude / Location of earthquake & stations
# Plot of three signals per station

if __name__ == '__main__':
    #checkargs()
    script, fpath, qpath, spath, destdir = sys.argv

    try:
        print "Loading", fpath
        st = obspy.read(fpath)
        filename = os.path.basename(fpath)
        
        read_quake_info( qpath )
        read_station_info( spath )

        #print(st)
      
        min_eventtime = None
        max_eventtime = None
        for tr in st:            
            eventtime = tr.stats.starttime
            endeventtime = tr.stats.endtime
            if min_eventtime == None:
                min_eventtime = eventtime
            elif min_eventtime > eventtime:
                min_eventtime = eventtime
            if max_eventtime == None:
                max_eventtime = endeventtime
            elif max_eventtime < endeventtime:
                max_eventtime = endeventtime

            #print tr.stats

            #print type( eventtime )
            ## get coordinates from inventory and add to waveform trace
            #trace.stats.coordinates = inv.get_coordinates(trace.get_id(), start)
            tr.stats.coordinates = ( station_info[ tr.stats.station ][ 'longitude' ], station_info[ tr.stats.station ][ 'latitude' ] )
            #tr.stats.distance = station_info[ tr.stats.station ][ 'distance' ] * 1000 + distance_offset[ tr.stats.channel ]
            
            ## compute distance in [m] between station and event and add to waveform trace
            (dist, azimut_AB, azimut_BA) = gps2dist_azimuth( quake_info[ 'latitude' ], quake_info[ 'longitude' ], station_info[ tr.stats.station ][ 'latitude' ],  station_info[ tr.stats.station ][ 'longitude' ] )
            print dist, azimut_AB, azimut_BA, tr.stats.channel
            tr.stats.distance = dist + distance_offset[ tr.stats.channel ]


        if not os.path.exists(destdir):
            try:
                os.makedirs(destdir)
            except IOError:
                error("Bad directory name %s" % destdir)
        
         # compute time window of interest (around event origin time)
        #start = evt.origins[0].time - pre_offset
        #end = evt.origins[0].time + post_offset
                
        #start = min_eventtime - pre_offset
        #end = max_eventtime + post_offset     
        #min_eventtime = 
        
        start = obspy.core.UTCDateTime( quake_info[ 'time' ] ) - pre_offset
        end = obspy.core.UTCDateTime( quake_info[ 'time' ] ) + post_offset

        #start = min_eventtime - pre_offset
        #end = max_eventtime + post_offset        


        st.filter('bandpass', freqmin=2.0, freqmax=20.0)

        path_img = os.path.join(destdir, filename + '-waveforms.png')
        print quake_info
        st.plot(
            type='section',
            ev_coord=( quake_info[ 'latitude' ], quake_info[ 'longitude' ] ),
            #ev_coords=( +53.23, +6.83 ),
            size=(920, 860),
            dpi=96,
            #color='#01689B',
            color='channel',
            linewidth=0.5,
            grid_linewidth=0.25,
            time_down=True,
            plot_dx=5e3,
            offset_min=0,
            norm_method='stream',
            starttime=start,
            endtime=end,
            #alpha=0.7,
            #dist_degree=True,
            outfile=path_img
        )
        #if verbose:
        #img = PIL_Image.open(path_img)
        #img.show(title=(filename + '-waveforms.png'))

    except IOError:
        error("Bad file path " + fpath)
            
