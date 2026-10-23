-- =============================================================================
-- Step 1: Dataset Scope, Yearly Record Counts & Distinct Users (2006–2017)
-- Project: listenbrainz1
-- Dataset: listenbrainz
-- Table:   listen_analysis
-- =============================================================================

SELECT
  EXTRACT(YEAR FROM listened_at) AS listen_year,
  COUNT(*) AS record_count,
  COUNT(DISTINCT user_name) AS distinct_users
FROM `listenbrainz1.listenbrainz.listen_analysis`
WHERE listened_at >= TIMESTAMP('2006-01-01 00:00:00 UTC')
  AND listened_at < TIMESTAMP('2018-01-01 00:00:00 UTC')
GROUP BY listen_year
ORDER BY listen_year ASC;
