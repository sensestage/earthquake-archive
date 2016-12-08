# Future Features:
# Normalization and DC offset removal in the converted wavefiles.
# Zero-buffering at the end of files to make all equal length.


import sys
import os
import obspy


def help_str():
    result = """
        Usage: python seed2wav.py SAMPLE_RATE FILE_NAME DEST_DIRECTORY
            SAMPLE_RATE:    Force sample rate to a specific value
                            or native to use native sampling rate.
            FILE_NAME:      mseed file to load
            DEST_DIRECTORY: directory to dump wav files for traces
    """
    return result

def error(msg):
    print "ERROR: ", msg
    sys.exit(0)

def checkargs():
    if len(sys.argv) < 4:
        error("Wrong number of input values" + help_str())
    script, srate, fname, destdir = sys.argv
    try:
        int(srate)
    except ValueError:
        if srate != 'native':
            error("Sample rate must be an integer value or native for native sampling rate.")

def writewav(trace, sr, dest):
    print trace.stats
    eventtime = trace.stats.starttime.strftime("_%Y-%m-%d_%H-%M-%S")
    stationcode = "%s_%s_%s" % (trace.stats.network, trace.stats.station, trace.stats.channel)
    #path = os.path.join(destdir, eventtime + stationcode + '.wav')
    path = os.path.join(destdir, stationcode + eventtime + '.wav')
    if sr == 'native':
        sr = tr.stats.sampling_rate
    tr.write(path, format='WAV', framerate=sr)
    print "Writing", path


if __name__ == '__main__':
    checkargs()
    script, srate, fpath, destdir = sys.argv
    if srate != 'native':
        srate = int(srate)

    try:
        print "Loading", fpath
        st = obspy.read(fpath)
        filename = os.path.basename(fpath)

        if not os.path.exists(destdir):
            try:
                os.makedirs(destdir)
            except IOError:
                error("Bad directory name %s" % destdir)

        for tr in st:
            writewav(tr, srate, destdir)
        print "...Done"

    except IOError:
        error("Bad file path " + fpath)
