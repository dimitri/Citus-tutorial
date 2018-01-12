---
--- https://docs.citusdata.com/en/v7.1/tutorials/real-time-analytics-tutorial.html
---

CREATE INDEX event_type_index ON github_events (event_type);
CREATE INDEX payload_index ON github_events USING GIN (payload jsonb_path_ops);
