# hornetq #

This is the hornetq module. It provides a puppet module for managing [HornetQ](http://hornetq.jboss.org/)

* This module is in an initial phase.  If you are using the source using a tool like r10k please be sure 
to fix it to a certain commit because currently no release plan is followed, everything is pushed to 
master.  When a version is released to the Puppet forge the Pupper module version will be increased.*

## Preparation
### Create a hornetq packages
First create a package to install HornetQ.  This can be done easily by getting the tarball and installing HornetQ from source.
```
cd /tmp
# wget http://.../hornetq-2.4.0.Final-bin.tar.gz  -> Get the binary distribution
yum install ruby-devel gcc
gem install fpm
tar -xvzf hornetq-2.4.0.Final-bin.tar.gz 
/tmp/hornetq-2.4.0.Final/lib/
cd /tmp/
mkdir -p /usr/local/hornetq/2.4.0
mv -v hornetq-2.4.0.Final/* /usr/local/hornetq/2.4.0/
cd /usr/local/hornetq/
fpm -s dir -t rpm -n hornetq -v 2.4.0 /usr/local/hornetq
mv hornetq-2.4.0-1.x86_64.rpm /tmp/
```
