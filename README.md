# Citus Tutorial

[CitusData](https://www.citusdata.com) is a
[PostgreSQL](https://www.postgresql.org) extension that intelligently
distributes your data & queries across many nodes so your database can scale
and your queries are fast.

They have a very nice tutorial on how to deal with [Multi-tenant
Applications](https://docs.citusdata.com/en/v7.1/tutorials/multi-tenant-tutorial.html)
and [Real-time
Analytics](https://docs.citusdata.com/en/v7.1/tutorials/real-time-analytics-tutorial.html)
when using Citus.

The tutorial is meant to be ran interactively. As a contributor to Citus
though, it makes sense to be able to run the tutorial again and again, for
instance after having modified the source code of the Citus extension.

This repository contains a couple of Makefiles that automates replaying the
Citus tutorials.

## Commands

The tutorial automation is based on a couple of Makefiles. Use as following:

### Do the whole tutorial from scratch

~~~ bash
$ make
~~~

This instanciate 3 PostgreSQL nodes on the local machine, setup Citus in
each of them, create the `citus` extension and register a coordinator and
two workers.

The coordinator runs on port 9700. Then workers are on ports 9701 and 9702.
All hard-coded, all exactly like in the tutorial online.

Then it proceeds to download Citus tutorial data files in `./data` and run
the tutorial CSV files that are checked-in into this repository.

### Clean-up

To clean up, just run the following command:

~~~ bash
$ make clean
~~~

It will remove the data files downloaded in `./data`, stop the 3 PostgreSQL
instances and remove their `PGDATA` directories.

### Other commands

Just poke around in the `./Makefile`, and have a look in the `./sql`
directory for the SQL sources, too.

If you're contributing to Citus, when you recompile the extension you want
to restart the whole cluster before playing around with it again, so that it
load the newer `citus.so` shared library again. This is as simple as just
typing `make restart`:

~~~ bash
$ make restart
make -C cluster restart
pg_ctl -D ./coordinator -o "-p 9700" stop
waiting for server to shut down.... done
server stopped
pg_ctl -D ./worker1 -o "-p 9701" stop
waiting for server to shut down.... done
server stopped
pg_ctl -D ./worker2 -o "-p 9702" stop
waiting for server to shut down.... done
server stopped
pg_ctl -D ./coordinator -o "-p 9700" -l coordinator.log start
waiting for server to start.... done
server started
pg_ctl -D ./worker1 -o "-p 9701" -l worker1.log start
waiting for server to start.... done
server started
pg_ctl -D ./worker2 -o "-p 9702" -l worker2.log start
waiting for server to start.... done
server started
~~~
