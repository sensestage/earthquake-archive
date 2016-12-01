### seed2wav.py
Script for converting mseed files into wav files.

### seed2plot.py
Script for visualizing mseed files

### seed2data.py
Extract useful earthquake and station data from a mseed file


### install obspy with miniconda

[miniconda download](http://conda.pydata.org/miniconda.html)
[miniconda install guide](http://conda.pydata.org/docs/install/quick.html)


    conda config --add channels conda-forge
    conda install obspy


Then miniconda replaces your default python (if you add it to the path) and you can start/stop scripts as usual with python seed2wav.py .....

*for images / maps*

    conda install pil
    conda install basemap
    conda install cartopy

    conda install -c conda-forge basemap-data-hires

    
### dependencies

## https://github.com/obspy/obspy/

On debian/ubuntu:

* python-pil

* python-future
* python-requests
* python-decorator
* python-matplotlib
* python-scipy
