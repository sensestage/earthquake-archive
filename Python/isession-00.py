from obspy import read
from sys import argv

script, datafile, audiodir = argv
st = read(datafile)
st.plot()

st.write(audiodir + "stream.wav", format="WAV", framerate=7000)
