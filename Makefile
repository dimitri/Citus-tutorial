all: cluster multi-tenant rt-analytics ;

clean: clean-cluster clean-data-files ;

cluster:
	$(MAKE) -C cluster all

CLUSTER_TARGETS = start stop restart ping status

$(CLUSTER_TARGETS):
	$(MAKE) -C cluster $@

clean-cluster: stop
	$(MAKE) -C cluster clean

clean-data-files:
	rm -f data/*.csv

multi-tenant: data multi-tenant-setup multi-tenant-copy multi-tenant-queries ;

multi-tenant-setup:
	PAGER=cat psql -p 9700 --single-transaction -f sql/multi-tenant-table.sql
	PAGER=cat psql -p 9700 --single-transaction -f sql/multi-tenant-pkey.sql
	PAGER=cat psql -p 9700 --single-transaction -f sql/multi-tenant-dist.sql

multi-tenant-copy:
	PAGER=cat psql -p 9700 --single-transaction -f sql/multi-tenant-copy.sql

multi-tenant-queries:
	PAGER=cat psql -p 9700 -a -f sql/multi-tenant-queries.sql

rt-analytics: data rt-analytics-setup rt-analytics-copy rt-analytics-queries ;

rt-analytics-setup:
	PAGER=cat psql -p 9700 --single-transaction -f sql/rt-analytics-table.sql
	PAGER=cat psql -p 9700 --single-transaction -f sql/rt-analytics-pkey.sql
	PAGER=cat psql -p 9700 --single-transaction -f sql/rt-analytics-dist.sql

rt-analytics-copy:
	PAGER=cat psql -p 9700 --single-transaction -f sql/rt-analytics-copy.sql

rt-analytics-queries:
	PAGER=cat psql -p 9700 -a -f sql/rt-analytics-queries.sql

data: data/companies.csv data/campaigns.csv data/ads.csv data/users.csv data/events.csv ;

data/companies.csv:
	curl https://examples.citusdata.com/tutorial/companies.csv > $@

data/campaigns.csv:
	curl https://examples.citusdata.com/tutorial/campaigns.csv > $@

data/ads.csv:
	curl https://examples.citusdata.com/tutorial/ads.csv > $@

data/users.csv:
	curl https://examples.citusdata.com/tutorial/users.csv > $@

data/events.csv:
	curl https://examples.citusdata.com/tutorial/events.csv > $@

psql:
	psql -p 9700

.PHONY: all cluster data multi-tenant rt-analytics psql
.PHONY: restart clean-cluster clean-data-files
