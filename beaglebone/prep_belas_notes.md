# git repo of earthquakes

    git clone nescivi@192.168.7.1:.local/git/earthquakes.git

    git pull origin master

    git remote add jreus jreus@192.168.7.1:/my/fancy/path/earthquakes.git

# in order to be able to update the files on the Bela

*Create a local git repository on your development machine, you will push your*
*changes to this repository in the same manner as pushing to Github.*
*This repository will be where the connected Bela will update its files from*
> git init --bare mylocalearthquake.git
*Go to your development repo and add a new remote repository*
> cd earthquake-archive/
> git remote add localearthquake ~/mylocalearthquake.git/
*Update your local repository with the latest files*
> git push localearthquake master

*Now ssh into the Bela. The project files are stored in the earthquakes directory*
> ssh root@192.168.7.2
> cd earthquakes/

*Add your new syncing repo to the Bela. Back up anything you need to and then do*
*a git pull from your remote repo.*
> git remote add jonmachine jon@192.168.7.1:/Volumes/Store/jon/mylocalearthquake.git
> mv Python/Test-Data/ Python/Test-Data-Old/
> git pull jonmachine master

*you may need to delete the RSA host key for 192.168.7.1 from known_hosts as its*
*possible someone else was working from a different machine with this Bela before you*
> nano /root/.ssh/known_hosts

*Hopefully after all that, the git pull will work. :-)*


# Being able to control SC on the Bela remotely.

*By default the Bela will automatically boot and run _main.scd*
*in order to stop this so you can play around...*
*When the Bela starts up it starts two sessions: 1 is the Bela IDE*
*the other is scsynth & sclang running _main.scd from the startup project*

*Get a list of the running sessions*
> screen -r

*To log into a process use*
> screen -r ID
*CTRL-C will stop a process when you're logged in to it*

*To disconnect from a process use CTRL-A + D*

*Once you have shut down the startup project. You can point your browser to the*
*Bela IDE http://192.168.7.2 and load up the startserver project. This will start*
*up the server so that you can play around.*

*From there you can go into the SuperCollider IDE and start coding.*
*First by making a connection to the Bela Server*
( // remote belaserver
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
//s.initTree;
s.options.maxLogins = 5;
s.clientID = 1;
s.startAliveThread;
);





# supercollider class extensions

*this doesn't work*
copy `bela_config/sclang_conf.yaml` to : `/root/.config/SuperCollider`

*so the old-fashioned way - also doesn't work*
    cd .local/share/SuperCollider/
    root@bela ~/.local/share/SuperCollider$ mkdir Extensions
    root@bela ~/.local/share/SuperCollider$ cd Extensions/
    root@bela ~/.local/share/SuperCollider/Extensions$ ls
    root@bela ~/.local/share/SuperCollider/Extensions$ ln -s /root/earthquakes/SuperCollider/classes/

*so add to /usr/local/share - this works*

    root@bela cd /usr/local/share/SuperCollider
    root@bela /usr/local/share/SuperCollider$ mkdir Extensions
    root@bela /usr/local/share/SuperCollider$ cd Extensions
    root@bela /usr/local/share/SuperCollider/Extensions$ ln -s /root/earthquakes/SuperCollider/classes/ Earthquakes



# update wavefiles:

from `/root/earthquakes/Python`
do

    rsync -av nescivi@192.168.7.1:/home/nescivi/git/projects/earthquakes/earthquake-archive/Python/Test-Data .

# To add the project to your bela
from `/root/Bela/projects`:

    ln -s /root/earthquakes/SuperCollider/EarthQuakeInstrument/

*You may also need to add the symlink for the SC class*
*so add to /usr/local/share - this works*

    root@bela cd /usr/local/share/SuperCollider
    root@bela /usr/local/share/SuperCollider$ mkdir Extensions
    root@bela /usr/local/share/SuperCollider$ cd Extensions
    root@bela /usr/local/share/SuperCollider/Extensions$ ln -s /root/earthquakes/SuperCollider/classes/ Earthquakes
