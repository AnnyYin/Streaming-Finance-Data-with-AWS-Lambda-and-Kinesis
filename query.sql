SELECT name AS Stock,
         (hour(cast(ts AS timestamp))-4) AS Hour,
         max(high) AS Highest_Price
FROM financedata22
GROUP BY  hour(cast(ts AS timestamp)), name
ORDER BY  hour(cast(ts AS timestamp)), name
