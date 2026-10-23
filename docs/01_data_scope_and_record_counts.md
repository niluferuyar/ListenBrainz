# Step 1: Dataset Scope & Yearly Listening Volume (2006–2017)

## 1. Objective
Establish the analysis scope on the `listenbrainz1.listenbrainz.listen_analysis` BigQuery table and quantify yearly listening activity between **2006 and 2017 (inclusive)**.

---

## 2. Dataset Metadata & Schema
- **BigQuery Table**: `listenbrainz1.listenbrainz.listen_analysis` (Location: `US`)
- **Total Unfiltered Rows**: `146,914,257`
- **Analysis Window**: `2006-01-01 00:00:00 UTC` $\le$ `listened_at` $<$ `2018-01-01 00:00:00 UTC`
- **Scoped Rows (2006–2017)**: `138,695,873` (**94.41%** of the entire table)

| Column | Type | Description |
| :--- | :--- | :--- |
| `listened_at` | `TIMESTAMP` | UTC timestamp when the listen event occurred |
| `user_name` | `STRING` | Unique identifier / username of the listener |
| `artist_name` | `STRING` | Artist name |
| `release_name` | `STRING` | Album / release title |
| `track_name` | `STRING` | Track title |
| `tags` | `STRING` | Associated metadata tags |

---

## 3. Yearly Record Count Breakdown (2006–2017)

![ListenBrainz Yearly Listening Volume (2006–2017)](../assets/figures/yearly_record_counts.svg)

| Year | Record Count | % of Scoped Dataset |
| :--- | ---: | ---: |
| **2006** | 4,426,017 | 3.19% |
| **2007** | 6,571,327 | 4.74% |
| **2008** | 8,241,289 | 5.94% |
| **2009** | 10,332,497 | 7.45% |
| **2010** | 10,916,567 | 7.87% |
| **2011** | 11,727,926 | 8.46% |
| **2012** | 12,584,358 | 9.07% |
| **2013** | 13,192,011 | 9.51% |
| **2014** | 13,976,162 | 10.08% |
| **2015** | 14,321,830 | 10.33% |
| **2016** | 15,599,457 | 11.25% |
| **2017** | 16,806,432 | 12.12% |
| **Total (2006–2017)** | **138,695,873** | **100.00%** |

---

## 4. Reproducible SQL Query
Source file: [`sql/01_yearly_record_counts.sql`](../sql/01_yearly_record_counts.sql)

```sql
SELECT
  EXTRACT(YEAR FROM listened_at) AS listen_year,
  COUNT(*) AS record_count
FROM `listenbrainz1.listenbrainz.listen_analysis`
WHERE listened_at >= TIMESTAMP('2006-01-01 00:00:00 UTC')
  AND listened_at < TIMESTAMP('2018-01-01 00:00:00 UTC')
GROUP BY listen_year
ORDER BY listen_year ASC;
```
