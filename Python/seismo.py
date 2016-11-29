import sys
import os
import obspy



def help_str():
    result = """
        Usage:
        seismo.py -MODE FILE_NAME DESTINATION_DIRECTORY
        Mode: -convert
        Mode: -plot
    """
    return result

def error(msg):
    print "ERROR:", msg
    sys.exit(0)

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


                destination = os.path.join(destdir, filename + '_' + tr.get_id() + '.wav')
                tr.write(destination, format='WAV', framerate=tr.stats.sampling_rate)
        elif mode == '-plot':
            st.plot(equal_scale=False)
    else:
        print help_str()
        sys.exit(0)
