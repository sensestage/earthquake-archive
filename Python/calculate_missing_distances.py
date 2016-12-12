from obspy.geodetics.base import gps2dist_azimuth



print "2011-06-27T15:48:09; 53.30; 6.79; 3.2; MLnq; manual"
#NL SUH4 -- HH*; +53.21; +6.21

(dist, azimut_AB, azimut_BA) = gps2dist_azimuth( 53.30, 6.79, 53.21, 6.21 )
print dist/1000

print "2012-08-16T20:30:33; 53.35; 6.67; 3.6; MLnq; manual"
#NL SUH4 -- HH*; +53.21; +6.21

(dist, azimut_AB, azimut_BA) = gps2dist_azimuth( 53.35, 6.67, 53.21, 6.21 )
print dist/1000

#(dist, azimut_AB, azimut_BA) = gps2dist_azimuth( quake_info[ 'latitude' ], quake_info[ 'longitude' ], station_info[ tr.stats.station ][ 'latitude' ],  station_info[ tr.stats.station ][ 'longitude' ] )