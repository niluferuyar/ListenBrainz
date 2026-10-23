-- =============================================================================
-- Step 2: Completed Inactivity Gap Summary & Percentile Statistics
-- Scope:  2006–2017 (inclusive), strictly positive gaps (inactive_days >= 1)
-- Note:   Back-to-back active days (inactive_days = 0) represent continuous
--         daily engagement and are excluded so they do not skew inactivity stats.
-- =============================================================================

WITH active_days AS (
  -- 1. Collapse multiple listens on the same calendar day into a single active day per user
  SELECT DISTINCT
    user_name,
    DATE(listened_at) AS active_date
  FROM `listenbrainz1.listenbrainz.listen_analysis`
  WHERE listened_at >= TIMESTAMP('2006-01-01 00:00:00 UTC')
    AND listened_at < TIMESTAMP('2018-01-01 00:00:00 UTC')
    AND user_name IS NOT NULL
),
gaps AS (
  -- 2. Order active days chronologically and measure inactive_days between consecutive active days
  SELECT
    user_name,
    active_date,
    LEAD(active_date) OVER (PARTITION BY user_name ORDER BY active_date) AS next_active_date,
    DATE_DIFF(
      LEAD(active_date) OVER (PARTITION BY user_name ORDER BY active_date),
      active_date,
      DAY
    ) - 1 AS inactive_days
  FROM active_days
),
completed_gaps AS (
  -- 3. Include only completed inactivity gaps with at least 1 inactive day (inactive_days >= 1)
  SELECT
    user_name,
    inactive_days
  FROM gaps
  WHERE next_active_date IS NOT NULL
    AND inactive_days >= 1
),
exact_percentiles AS (
  -- 4. Compute exact percentiles across completed inactivity gaps
  SELECT DISTINCT
    PERCENTILE_CONT(inactive_days, 0.50) OVER() AS p50,
    PERCENTILE_CONT(inactive_days, 0.75) OVER() AS p75,
    PERCENTILE_CONT(inactive_days, 0.90) OVER() AS p90,
    PERCENTILE_CONT(inactive_days, 0.95) OVER() AS p95,
    PERCENTILE_CONT(inactive_days, 0.99) OVER() AS p99
  FROM completed_gaps
)
SELECT
  COUNT(*) AS total_completed_gaps,
  COUNT(DISTINCT user_name) AS distinct_users,
  ROUND(AVG(inactive_days), 2) AS mean_inactive_days,
  ROUND(STDDEV_SAMP(inactive_days), 2) AS stddev_inactive_days,
  MAX(p.p50) AS p50_median,
  MAX(p.p75) AS p75,
  MAX(p.p90) AS p90,
  MAX(p.p95) AS p95,
  MAX(p.p99) AS p99,
  ROUND(100.0 * COUNTIF(inactive_days > 30) / COUNT(*), 2) AS pct_exceeding_30d,
  ROUND(100.0 * COUNTIF(inactive_days > 60) / COUNT(*), 2) AS pct_exceeding_60d,
  ROUND(100.0 * COUNTIF(inactive_days > 90) / COUNT(*), 2) AS pct_exceeding_90d,
  ROUND(100.0 * COUNTIF(inactive_days > 180) / COUNT(*), 2) AS pct_exceeding_180d
FROM completed_gaps
CROSS JOIN exact_percentiles p;
