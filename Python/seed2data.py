import sys
import os
import obspy

# Make a file with lat & long for stations & for earthquakes
# Can be done from the streams?
# Options for visual plots for each earthquake
# Earthquake magnitude / Location of earthquake & stations
# Plot of three signals per station


def help_str():
    result = """
        Usage: python seed2plot.py

    """
    return result

def error(msg):
    print "ERROR:", msg
    sys.exit(0)

# TODOS:
# Add option to force sample rate or use original
# Make a file with lat & long for stations & for earthquakes
# Can be done from the streams?
# Options for visual plots for each earthquake
# Earthquake magnitude / Location of earthquake & stations
# Plot of three signals per station

if __name__ == '__main__':
    script, mode, filename, destdir = sys.argv

    if mode in ['-towav', '-plot']:
        try:
            print "Loading", filename
            st = obspy.read(filename)
        except IOError:
            error("Bad file name")

        if mode == '-towav':
            if not os.path.exits(destdir):
                error("Bad destination directory")

            for tr in st:
                #tr.plot()
        elif mode == '-plot':
            st.plot(equal_scale=False)


                destination = os.path.join(destdir, filename + '_' + tr.get_id() + '.wav')
                tr.write(destination, format='WAV', framerate=tr.stats.sampling_rate)
        elif mode == '-plot':
            st.plot(equal_scale=False)
    else:
        print help_str()
        sys.exit(0)
