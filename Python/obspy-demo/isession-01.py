# coding: utf-8

get_ipython().show_usage()
a = "Hello World"
get_ipython().magic(u'pinfo a')
get_ipython().magic(u'pinfo2 a')
get_ipython().magic(u'pinfo a')
import matplotlib.pyplot as plt
from obspy import read
st = read("KNMI_Data/Jon-2014-11-05-M2.9-HGZ.mseed")
st[0]
st[0]?
st[0]
st.plot()
st[0].data
max(st[0].data)
min(st[0].data)
min(st[2].data)
max(st[2].data)
plt.plot(st[2].data)
plt.plot([1,2,3,4])
plt.plot(st[2].data)
plt.ylabel('some numbers')
plt.show()
import wave
f = wave.open("WAV/mywave.wav", 'w')
f.setnchannels(1)
f.setsampwidth(4)
f.setframerate(7000)
f.writeframes(s[2].data)
f.writeframes(st[2].data)
f.close()
