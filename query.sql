WITH 
    t1 AS (
      SELECT name, high, ts, substring(ts,12,2) AS hour 
      FROM financedata22
      ), 
    t2 AS (
      SELECT name, substring(ts,12,2) AS hour, MAX(high) AS max_high 
      FROM financedata22
      GROUP BY  name, substring(ts, 12, 2)
      )

SELECT
    t1.name AS Stock, 
    t1.hour AS Hour, 
    t2.max_high AS Hourly_High, 
    substring(t1.ts,1,19) AS Datetime
FROM 
    t1 INNER JOIN t2 ON 
    t1.name = t2.name AND t1.hour = t2.hour AND t1.high = t2.max_high
ORDER BY  Stock, Hour, Datetime
