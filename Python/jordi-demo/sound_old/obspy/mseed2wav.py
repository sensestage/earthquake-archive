#! /usr/bin/python 

import sys
import obspy

st = obspy.read(sys.argv[1])

print st
st.plot(equal_scale=False)

for tr in st:
    #tr.plot()
    tr.write(sys.argv[1] + '_' + tr.get_id() + '.wav', format='WAV', framerate=7000)
