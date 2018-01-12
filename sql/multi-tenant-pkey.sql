---
--- https://docs.citusdata.com/en/v7.1/tutorials/multi-tenant-tutorial.html
---

ALTER TABLE companies ADD PRIMARY KEY (id);
ALTER TABLE campaigns ADD PRIMARY KEY (id, company_id);
ALTER TABLE ads ADD PRIMARY KEY (id, company_id);
