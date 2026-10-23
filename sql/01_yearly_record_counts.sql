-- =============================================================================
-- Step 1: Dataset Scope & Yearly Record Counts (2006–2017 Inclusive)
-- Project: listenbrainz1
-- Dataset: listenbrainz
-- Table:   listen_analysis
-- =============================================================================

SELECT
  EXTRACT(YEAR FROM listened_at) AS listen_year,
  COUNT(*) AS record_count
FROM `listenbrainz1.listenbrainz.listen_analysis`
WHERE listened_at >= TIMESTAMP('2006-01-01 00:00:00 UTC')
  AND listened_at < TIMESTAMP('2018-01-01 00:00:00 UTC')
GROUP BY listen_year
ORDER BY listen_year ASC;
