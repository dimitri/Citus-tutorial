---
--- https://docs.citusdata.com/en/v7.1/tutorials/multi-tenant-tutorial.html
---

INSERT INTO companies
     VALUES (5000, 'New Company', 'https://randomurl/image.png', now(), now());

UPDATE campaigns
   SET monthly_budget = monthly_budget*2
 WHERE company_id = 5;

BEGIN;
  DELETE from campaigns where id = 46 AND company_id = 5;
  DELETE from ads where campaign_id = 46 AND company_id = 5;
COMMIT;

  SELECT name, cost_model, state, monthly_budget
    FROM campaigns
   WHERE company_id = 5
ORDER BY monthly_budget DESC
   LIMIT 10;

  SELECT campaigns.id, campaigns.name, campaigns.monthly_budget,
         sum(impressions_count) as total_impressions,
         sum(clicks_count) as total_clicks
  
    FROM ads, campaigns
  
   WHERE ads.company_id = campaigns.company_id
     AND campaigns.company_id = 5
     AND campaigns.state = 'running'
     
GROUP BY campaigns.id, campaigns.name, campaigns.monthly_budget
ORDER BY total_impressions, total_clicks;

---
--- Rewrite of the previous query with a proper JOIN syntax
---
  select campaigns.id, campaigns.name, campaigns.monthly_budget,
         sum(impressions_count) as total_impressions,
         sum(clicks_count) as total_clicks
  
    from ads join campaigns using (company_id)
  
   where campaigns.company_id = 5
     and campaigns.state = 'running'
     
group by campaigns.id, campaigns.name, campaigns.monthly_budget
order by total_impressions, total_clicks;
