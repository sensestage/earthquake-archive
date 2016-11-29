# coding: utf-8

st
from obspy import read
st = read("KNMI_Data/Jon-2014-11-05-M2.9-HGZ.mseed")
st.plot()
data = st[2].data
np
import numpy as np
get_ipython().magic(u'pinfo data')
max(data)
max(data)
min(data)
scaled = data / 24960.0
data
new = np.asarray(data, dtype=np.float32)
new
scaled
new
new = new / 24960.0
new
import wave
fp = wave.open("WAV/mywave.wav",'w')
fp.setframerate(7000)
fp.setnchannels(1)
fp.write(new)
fp.writeframes(new)
fp.setsampwidth(4)
fp.writeframes(new)
fp.close()
