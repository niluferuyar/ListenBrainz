-- =============================================================================
-- Step 3: Returning Users After Extended Inactivity (>= 90 Days)
-- Creates table: listenbrainz1.listenbrainz.users_inactive_90plus_days
-- =============================================================================

CREATE OR REPLACE TABLE `listenbrainz1.listenbrainz.users_inactive_90plus_days` AS
WITH active_days AS (
  SELECT DISTINCT
    user_name,
    DATE(listened_at) AS active_date
  FROM `listenbrainz1.listenbrainz.listen_analysis`
  WHERE listened_at >= TIMESTAMP('2006-01-01 00:00:00 UTC')
    AND listened_at < TIMESTAMP('2018-01-01 00:00:00 UTC')
    AND user_name IS NOT NULL
),
gaps AS (
  SELECT
    user_name,
    DATE_DIFF(
      LEAD(active_date) OVER (PARTITION BY user_name ORDER BY active_date),
      active_date,
      DAY
    ) - 1 AS inactive_days
  FROM active_days
),
user_summary AS (
  SELECT
    user_name,
    MAX(inactive_days) AS max_inactive_days_before_return,
    COUNT(*) AS gte_90_return_count,
    STRING_AGG(CAST(inactive_days AS STRING), ', ' ORDER BY inactive_days DESC) AS all_gte_90_gaps_days
  FROM gaps
  WHERE inactive_days >= 90
  GROUP BY user_name
)
SELECT
  ROW_NUMBER() OVER (ORDER BY max_inactive_days_before_return DESC, gte_90_return_count DESC, user_name) AS rank,
  user_name,
  max_inactive_days_before_return,
  gte_90_return_count,
  all_gte_90_gaps_days
FROM user_summary
ORDER BY rank;
