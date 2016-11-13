from obspy import read
from sys import argv

script, datafile, audiodir = argv
print argv
st = read(datafile)
st.plot()

st.write(audiodir + "stream.wav", format="WAV", framerate=300)

for tr in st:
    tr.write(audiodir + tr.id + ".wav", format="WAV", framerate=300)
