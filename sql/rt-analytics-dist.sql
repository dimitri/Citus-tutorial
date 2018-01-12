---
--- https://docs.citusdata.com/en/v7.1/tutorials/real-time-analytics-tutorial.html
---

SELECT create_distributed_table('github_users', 'user_id');
SELECT create_distributed_table('github_events', 'user_id');
