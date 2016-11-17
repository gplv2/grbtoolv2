[Open Source Love](https://badges.frapsoft.com/os/gpl/gpl.svg?v=102)
[Scrutinizer Quality Score](https://scrutinizer-ci.com/g/gplv2/grbtool/badges/quality-score.png?s=4023c984fc1163a44f4220cd7d57406643ced9f2)
[Code Coverage](https://scrutinizer-ci.com/g/gplv2/grbtool/badges/coverage.png?s=531ebd5f55891dfc816ace082531adfb24d194e9)
[Build](https://scrutinizer-ci.com/g/gplv2/grbtool/badges/build.png?b=master)

## Coveralls

# grbtool
GRB-GIMT: GRB GUI Import and Merge Tool.  Production site for GRB import work flemish part of Belgium

# Installing
You'll need vagrant and Virtualbox.  Clone the repo locally, This repository complete install itself using '''vagrant up'''.   At this point, it will install everything automatically and also download a database dump and import it into PostGis.

# vagrant up:

 - install/upgrade 16.04 Base Ubuntu installation
 - install PHP 7 and libraries
 - install GRB GIMT
 - configure nginx + phpfpm
 - configure postgresql/postgis
 - download database dump (be gently on the host)
 - import dump
 - deploy framework (Laravel 5.3) + node.js
 - perform the usual post install laravel jobs
 
It's using my own custom installation scripts as I have had lots of issues with particular tasks in Ansible/Puppet etc.  For example some wget commands fail with segfaults when you're not using --quiet option inside a provisioner.  The provisioner is therefor a bit dumb, so you should only run it once.

When it's done, you can visit the bridged ip remotely or the internal IP via the host OS to access the webserver.  The only thing you need to do is add a host mapping to your /etc/hosts file (linux) or equivalent for your OS.
This mapping should point to the IP address you want to visit.

Standard name of the app is : grb.app

So you'll do something like this in /etc/hosts (local):

    192.168.6.218 grb.app
    192.168.6.218 api.grb.app
    192.168.6.218 admin.grb.app

When that is done, you can visit the application at http://grb.app  (or https but the key is self-signed, so your browser will complain)

# notes

This is NOT the tool used to extract/create the source database this tool will use.  That is a bit more complex and involves many steps. The tools for building this DB are https://github.com/gplv2/grb2pgsql and  https://github.com/gplv2/grb2osm .  Be aware that this is quite a complex process and it's possible that not every step has been documented yet.  When rebuilding this database with updated GRB data, this procedure will be verified and completed.  This repo concerns the frontend website and backend api only.
