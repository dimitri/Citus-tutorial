---
--- https://docs.citusdata.com/en/v7.1/tutorials/multi-tenant-tutorial.html
---

SELECT create_distributed_table('companies', 'id');
SELECT create_distributed_table('campaigns', 'company_id');
SELECT create_distributed_table('ads', 'company_id');
