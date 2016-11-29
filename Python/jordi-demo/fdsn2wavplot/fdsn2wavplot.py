#! /usr/bin/env python

import os
from PIL import Image as PIL_Image
from obspy.clients.fdsn import Client
from obspy.geodetics.base import gps2dist_azimuth


# Configuration:
#
# Plots directory (output)
data_dir = './data'
#
# KNMI's FDSN webservice. User must be registered at:
# http://rdsa.knmi.nl/dataportal/registration.html
server = 'http://rdsa.knmi.nl/'
user = 'user@example.nl'
#
# Time window to plot (in seconds around event origin time)
pre_offset = 0
post_offset = 16
#
# Max distance from epicenter to download waveforms (in km)
max_dist = 10.0
#
# Save waveforms to sound or not
# (WARNING! it can consume more space and time)
save_sound = True
#
# Verbose: show more info and images while running
# (WARNING! it will pop up 2 images per event)
verbose = True


# Program:
#
try:

    # make sure output dir exists
    if not os.path.exists(data_dir):
        os.makedirs(data_dir)

    # create client to FDSN webservice
    client = Client(base_url=server, user=user, password='', debug=False)

    # find events of interest
    print "Downloading events..."
    catalog = client.get_events(

        # province of Groningen
        minlatitude=53.1,
        maxlatitude=53.5,
        minlongitude=6.5,
        maxlongitude=7.2,

        # biggest events (magnitude >= 2)
        minmag=2.0,

        # only last 20
        limit=20,

        # time contraints
        #starttime=obspy.UTCDateTime('2016-06-01'),
        #endtime=obspy.UTCDateTime('2017-01-01'),

        # one specific event
        #eventid="knmi2016vlii",

        # other options
        includeallorigins=False,
        includearrivals=True,
    )

    # make map of events
    print "Plotting map of events..."
    path_img_catalog = os.path.join(data_dir, 'events-map.png')
    catalog.plot(projection='local', resolution='i', color='date', outfile=path_img_catalog)
    if verbose:
        img = PIL_Image.open(path_img_catalog)
        img.show(title='events-map.png')
    print ""

    # for each earthquake
    for evt in catalog:

        # get event ID
        evt_id = evt.resource_id.id.split('/').pop()
        print "Processing event...", evt_id
        if verbose:
            print evt

        # create data dir for this event
        event_dir = os.path.join(data_dir, evt_id)
        if not os.path.exists(event_dir):
            os.makedirs(event_dir)

        # save event description
        print "Printing short event description for...", evt_id
        path_desc = os.path.join(event_dir, evt_id + '-description.txt')
        with open(path_desc, 'a') as file_desc:
            file_desc.write(evt.short_str() + '\n')

        # compute time window of interest (around event origin time)
        start = evt.origins[0].time - pre_offset
        end = evt.origins[0].time + post_offset

        # loop arrivals and picks (of interest),
        # to get the list of stations to download
        wids = []
        if verbose:
            print "Stations of interest:"
        for arrival in evt.origins[0].arrivals:
            # Only if the arrival is of interest
            if arrival.phase == 'P' and arrival.time_weight > 0 and \
                    arrival.distance * 111.1 <= max_dist:
                # get pick and save WaveformStreamID
                pick = arrival.pick_id.get_referred_object()
                wids.append(pick.waveform_id)
                if verbose:
                    print str(pick.waveform_id.get_seed_string())

        # make bulk request string (list stations/times of interest)
        # for downloading both waveforms and inventory
        bulk = []
        for wid in wids:
            bulk.append((
                wid.network_code,
                wid.station_code,
                wid.location_code,
                # only channel used for pick,
                # put '*' for all channels
                wid.channel_code,
                start - 5, end + 5
            ))

        # request inventory
        print "Downloading inventory data for...", evt_id
        inv = client.get_stations_bulk(bulk, level='channel')
        if verbose:
            print inv

        # make map of event and stations
        print "Plotting map of event and stations for...", evt_id
        path_img_map = os.path.join(event_dir, evt_id + '-map.png')
        fig = inv.plot(projection='local', resolution='i', label=True, show=False)
        new_cat = catalog.filter("time > " + str(evt.origins[0].time - 1), "time < " + str(evt.origins[0].time + 1))
        new_cat.plot(projection='local', resolution='i', fig=fig, outfile=path_img_map)
        if verbose:
            img = PIL_Image.open(path_img_map)
            img.show(title=(evt_id + '-map.png'))

        # request waveforms
        print "Downloading waveform data for...", evt_id
        stream = client.get_waveforms_bulk(bulk, attach_response=False)
        if verbose:
            print stream

        # save waveforms to sound
        if save_sound:
            print "Saving waveforms to sound for...", evt_id
            wav_dir = os.path.join(event_dir, 'WAV')
            if not os.path.exists(wav_dir):
                os.makedirs(wav_dir)
            for trace in stream:
                path_wav = os.path.join(wav_dir, trace.get_id() + '.wav')
                trace.write(path_wav, format='WAV', framerate=2000)

        # filter waveforms in frequency
        print "Filtering waveforms for...", evt_id
        stream.filter('bandpass', freqmin=2.0, freqmax=20.0)

        # add coordinates to streams (in order to make a section plot)
        print "Adding station coordinates to waveforms for...", evt_id
        for trace in stream:

            # get coordinates from inventory and add to waveform trace
            trace.stats.coordinates = inv.get_coordinates(trace.get_id(), start)

            # compute distance in [m] between station and event and add to waveform trace
            (dist, azimut_AB, azimut_BA) = gps2dist_azimuth(evt.origins[0].latitude, evt.origins[0].longitude, trace.stats.coordinates.latitude, trace.stats.coordinates.longitude)
            trace.stats.distance = dist

        # make plot
        print "Plotting waveforms for...", evt_id
        path_img_wav = os.path.join(event_dir, evt_id + '-waveforms.png')
        stream.plot(
            type='section',
            ev_coord=(evt.origins[0].latitude, evt.origins[0].longitude),
            size=(920, 860),
            dpi=96,
            color='#01689B',
            linewidth=0.5,
            grid_linewidth=0.25,
            time_down=True,
            plot_dx=10e3,
            offset_min=0,
            starttime=start,
            endtime=end,
            #alpha=0.7,
            #dist_degree=True,
            outfile=path_img_wav
        )
        if verbose:
            img = PIL_Image.open(path_img_wav)
            img.show(title=(evt_id + '-waveforms.png'))

        print "Done with event %s -> %s" % (evt_id, path_img_map)
        print "                             -> %s" % (path_img_wav)
        print "                             -> %s" % (path_desc)
        if save_sound:
            print "                             -> %s" % (wav_dir)
        print ""

except Exception as e:
    print "Error:", str(e)
