all: clean worker1 worker2 coordinator;

coordinator:
	initdb -D ./coordinator
	echo "shared_preload_libraries = 'citus'" >> ./coordinator/postgresql.conf
	echo "citus.log_remote_commands = on" >> ./coordinator/postgresql.conf
	pg_ctl -D ./coordinator -o "-p 9700" -l coordinator.log start
	createdb -p 9700 $(USER)
	psql -p 9700 -c "CREATE EXTENSION citus;"
	psql -p 9700 -c "SELECT * from master_add_node('localhost', 9701);"
	psql -p 9700 -c "SELECT * from master_add_node('localhost', 9702);"
	psql -p 9700 -c "select * from master_get_active_worker_nodes();"

worker1:
	mkdir -p ./worker1
	rm -rf ./worker1/*
	initdb -D ./worker1
	echo "shared_preload_libraries = 'citus'" >> ./worker1/postgresql.conf
	pg_ctl -D ./worker1 -o "-p 9701" -l worker1.log start
	createdb -p 9701 $(USER)
	psql -p 9701 -c "CREATE EXTENSION citus;"

worker2:
	initdb -D ./worker2
	echo "shared_preload_libraries = 'citus'" >> ./worker2/postgresql.conf
	pg_ctl -D ./worker2 -o "-p 9702" -l worker2.log start
	createdb -p 9702 $(USER)
	psql -p 9702 -c "CREATE EXTENSION citus;"

start:
	pg_ctl -D ./coordinator -o "-p 9700" -l coordinator.log start
	pg_ctl -D ./worker1 -o "-p 9701" -l worker1.log start
	pg_ctl -D ./worker2 -o "-p 9702" -l worker2.log start

stop:
	-pg_ctl -D ./coordinator -o "-p 9700" stop
	-pg_ctl -D ./worker1 -o "-p 9701" stop
	-pg_ctl -D ./worker2 -o "-p 9702" stop

ping:
	-pg_isready -p 9700
	-pg_isready -p 9701
	-pg_isready -p 9702

status: ping ;

restart: stop start ;

clean: stop
	rm -rf coordinator/* worker1/* worker2/*

.PHONY: coordinator worker1 worker2 stop start restart status clean ping
