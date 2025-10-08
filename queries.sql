-- First of all, I created a CTE which will contain a table of all our 5 initial tables joined
WITH artists_info AS(
SELECT 
        a.id,
        a.name,
        a.country,
        sp.total_streams,
        sp.monthly_listeners,
        c.biggest_tour,
        c.biggest_tour_revenue,
        so.billion_streams_hits,
        SUM(aw.grammys + aw.vma + aw.ama) AS total_awards
	FROM artists a
    LEFT JOIN spotify sp ON a.id = sp.id
    LEFT JOIN concerts c ON a.id = c.id
    LEFT JOIN awards aw ON a.id = aw.id
    LEFT JOIN songs so ON a.id = so.id
    WHERE sp.total_streams IS NOT NULL
-- GROUP BY is used here to use SUM() function above 
    GROUP BY 
        a.id, a.name, a.country,
        sp.total_streams, sp.monthly_listeners,
        c.biggest_tour, c.biggest_tour_revenue,
        so.billion_streams_hits
)
(
-- This part of the query helps to find the 3 biggest artists from the list based on total quantity of their awards
SELECT 
    ai.name,
    ai.country,
    ai.total_streams,
    ai.biggest_tour,
    ai.biggest_tour_revenue,
    ai.total_awards,
    'Top_3_by_awards' AS category,
    (
-- I'll be honest: I just needed to use a subquery, so I decided to check the average streams among all artists in the table:)
    SELECT AVG(total_streams) 
    FROM artists_info ai
    ) AS avg_streams
FROM artists_info ai
GROUP BY
ai.name, ai.country, ai.total_streams, ai.biggest_tour, 
        ai.biggest_tour_revenue, ai.total_awards
HAVING total_streams > 0 
ORDER BY total_streams DESC
LIMIT 3
)
-- Here I use UNION to create two top-3 lists based on different criteria and put them together in one table
UNION 
(
-- This part of the query helps to find the 3 biggest artists from the list based on their total streams 
-- Total streams are the sum of how many times people have listened to each of an artist’s songs
SELECT 
    ai.name,
    ai.country,
    ai.total_streams,
    ai.biggest_tour,
    ai.biggest_tour_revenue,
    ai.total_awards,
    'Top_3_by_streams' AS category,
-- I put NULL here because I need both SELECTS to have the same structure to UNION them (and average streams have nothing to do with awards)
    NULL AS avg_streams 
FROM artists_info ai
GROUP BY
ai.name, ai.country, ai.total_streams, ai.biggest_tour, 
        ai.biggest_tour_revenue, ai.total_awards
HAVING total_awards > 10 
ORDER BY total_awards DESC
LIMIT 3
);

