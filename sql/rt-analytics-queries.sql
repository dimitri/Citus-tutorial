---
--- https://docs.citusdata.com/en/v7.1/tutorials/real-time-analytics-tutorial.html
---

SELECT count(*) FROM github_users;

  SELECT date_trunc('minute', created_at) AS minute,
         sum((payload->>'distinct_size')::int) AS num_commits
    FROM github_events
   WHERE event_type = 'PushEvent'
GROUP BY minute
ORDER BY minute;

  SELECT login, count(*)
    FROM github_events ge
         JOIN github_users gu
           ON ge.user_id = gu.user_id
   WHERE event_type = 'CreateEvent' AND payload @> '{"ref_type": "repository"}'
GROUP BY login
ORDER BY count(*) DESC LIMIT 10;
