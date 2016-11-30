### Nov 30 2016
- The KNMI web interface doesn't include location data for stations in the mseed files
- that are downloaded. unfortunately this means that the only way to get the location data
- programmatically is to use the web API
https://docs.obspy.org/packages/obspy.clients.fdsn.html#module-obspy.clients.fdsn

- obspy.geodetics.gps2dist_azimuth - gives you a roundabout method for calculating
- distances manually.
 https://docs.obspy.org/packages/obspy.geodetics.html
