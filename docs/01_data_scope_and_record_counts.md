# Step 1: Dataset Scope, Yearly Listening Volume & Distinct Users (2006–2017)

## 1. Objective
Establish the analysis scope on the `listenbrainz1.listenbrainz.listen_analysis` BigQuery table and quantify both yearly listening volume (`record_count`) and active listener count (`distinct_users`) between **2006 and 2017 (inclusive)**.

---

## 2. Dataset Metadata & Schema
- **BigQuery Table**: `listenbrainz1.listenbrainz.listen_analysis` (Location: `US`)
- **Total Unfiltered Rows**: `146,914,257`
- **Analysis Window**: `2006-01-01 00:00:00 UTC <= listened_at < 2018-01-01 00:00:00 UTC`
- **Scoped Rows (2006–2017)**: `138,695,873` (**94.41%** of the entire table)
- **Total Distinct Users (2006–2017)**: `2,039`

| Column | Type | Description |
| :--- | :--- | :--- |
| `listened_at` | `TIMESTAMP` | UTC timestamp when the listen event occurred |
| `user_name` | `STRING` | Unique identifier / username of the listener |
| `artist_name` | `STRING` | Artist name |
| `release_name` | `STRING` | Album / release title |
| `track_name` | `STRING` | Track title |
| `tags` | `STRING` | Associated metadata tags |

---

## 3. Yearly Record Count & Distinct User Breakdown (2006–2017)

### 3.1 Yearly Listening Volume (`record_count`)
![ListenBrainz Yearly Listening Volume (2006–2017)](../assets/figures/yearly_record_counts.svg)

### 3.2 Yearly Distinct User Count (`distinct_users`)
![ListenBrainz Yearly Distinct User Count (2006–2017)](../assets/figures/yearly_distinct_users.svg)

### 3.3 Yearly Summary Table

| Year | Record Count | % of Scoped Dataset | Distinct Users | % of Total Scoped Users (N = 2,039) |
| :--- | ---: | ---: | ---: | ---: |
| **2006** | 4,426,017 | 3.19% | 441 | 21.63% |
| **2007** | 6,571,327 | 4.74% | 635 | 31.14% |
| **2008** | 8,241,289 | 5.94% | 802 | 39.33% |
| **2009** | 10,332,497 | 7.45% | 943 | 46.25% |
| **2010** | 10,916,567 | 7.87% | 1,034 | 50.71% |
| **2011** | 11,727,926 | 8.46% | 1,109 | 54.39% |
| **2012** | 12,584,358 | 9.07% | 1,197 | 58.71% |
| **2013** | 13,192,011 | 9.51% | 1,289 | 63.22% |
| **2014** | 13,976,162 | 10.08% | 1,402 | 68.76% |
| **2015** | 14,321,830 | 10.33% | 1,516 | 74.35% |
| **2016** | 15,599,457 | 11.25% | 1,612 | 79.06% |
| **2017** | 16,806,432 | 12.12% | 1,893 | 92.84% |
| **Total (2006–2017)** | **138,695,873** | **100.00%** | **2,039** *(unique across window)* | **100.00%** |

---

## 4. Reproducible SQL Query
Source file: [`sql/01_yearly_record_counts.sql`](../sql/01_yearly_record_counts.sql)

```sql
SELECT
  EXTRACT(YEAR FROM listened_at) AS listen_year,
  COUNT(*) AS record_count,
  COUNT(DISTINCT user_name) AS distinct_users
FROM `listenbrainz1.listenbrainz.listen_analysis`
WHERE listened_at >= TIMESTAMP('2006-01-01 00:00:00 UTC')
  AND listened_at < TIMESTAMP('2018-01-01 00:00:00 UTC')
GROUP BY listen_year
ORDER BY listen_year ASC;
```
