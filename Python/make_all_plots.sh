#!/bin/sh 

for i in Test-Data/* ; do
  seedfile=`find $i/*.mseed`
  echo $seedfile
#   python seed2plot.py $seedfile $i/quake_info.csv $i/distance_info.csv Plots/
#   python seed2plot.py $seedfile $i/quake_info.csv $i/station_info.csv Plots2/
  python seed2plot.py $seedfile $i/quake_info.csv $i/station_info.csv Plots3/
done

# python seed2plot.py Test-Data/2003-11-10-3.0/Package_1480501822584-KNMI_8135_KNMI.mseed Test-Data/2003-11-10-3.0/quake_info.csv Test-Data/2003-11-10-3.0/distance_info.csv Plots/
