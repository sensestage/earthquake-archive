#Steps done to update a Bela

Following [https://github.com/BelaPlatform/Bela/wiki/Updating%20Bela](https://github.com/BelaPlatform/Bela/wiki/Updating%20Bela)

* download latest master
* update to board

Update SC

* [http://forum.bela.io/d/53-supercollider-on-bela/31](http://forum.bela.io/d/53-supercollider-on-bela/31)
* [https://github.com/giuliomoro/supercollider/releases/tag/3.8dev-Bela-build_20161024](http://forum.bela.io/d/53-supercollider-on-bela/31)

However missing libudev in runtime:

* make connection to internet and set time
* apt-get update
* apt-get install libudev1
* 