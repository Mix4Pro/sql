

-- Найди сумму продаж по каждому региону.
SELECT region , SUM(amount)
FROM sales
GROUP BY region

-- Покажи среднюю сумму продаж по регионам, где больше одной продажи.
SELECT region , AVG(amount)
FROM sales
WHERE amount > 1
GROUP BY region

-- Найди регион с максимальной суммой продаж.
SELECT region , COALESCE(SUM(amount),0) AS combined_amount
FROM sales
GROUP BY region
ORDER BY combined_amount DESC
LIMIT 1

-- Выведи общее количество продаж и сколько из них имеют ненулевую сумму.
SELECT COUNT (*) , COUNT (amount) AS sales_with_amount
FROM sales

-- Покажи регионы, где продажи превышают среднюю по всем регионам.
SELECT region, SUM(COALESCE(amount, 0)) AS total_region_sales
FROM sales
GROUP BY region
HAVING SUM(COALESCE(amount, 0)) > (
    SELECT AVG(region_total_sum) FROM (
		SELECT SUM(COALESCE(amount, 0)) AS region_total_sum
        FROM sales
        GROUP BY region
    ) AS regional_summary
);