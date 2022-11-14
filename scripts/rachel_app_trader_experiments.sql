WITH distinct_appstores AS
	(SELECT
	 	DISTINCT name,
	 	app_store_apps.price::money AS app_price,
	 	app_store_apps.rating AS app_rating,
	 	app_store_apps.primary_genre AS app_genre,
	 	app_store_apps.review_count::integer AS app_review_count,
	 	play_store_apps.price::money AS play_price,
	 	play_store_apps.rating AS play_rating,
	 	play_store_apps.category AS play_genre,
	 	play_store_apps.review_count AS play_review_count,
	 	(app_store_apps.price::money + play_store_apps.price::money)/2 AS avg_price,
	 	ROUND((app_store_apps.rating + play_store_apps.rating)/50,2)*25 AS avg_rating,
	 	(app_store_apps.review_count::integer + play_store_apps.review_count)/2 AS avg_review_count,
       CASE WHEN ((app_store_apps.price::money + play_store_apps.price::money)/2)::numeric >=2.5 THEN
	 		(((app_store_apps.price::money + play_store_apps.price::money)/2)::numeric *10000)
	 	ELSE 25000 END AS avg_price_to_purchase,
            ROUND(((ROUND((app_store_apps.rating + play_store_apps.rating)/50,2)*25 * 2) + 1), 1) AS lifespan_yrs
FROM app_store_apps INNER JOIN play_store_apps USING(name))

/* Analysis for most popular category in the Android Play Store.
   Conclusion: Almost 20% of Android Play App apps are in the 'Family' category 
   with 'Game' constituting about 11%, together these categories make up almost 30%
   of Android Play Store's consumer market.
*/
SELECT category,
       count(category) AS category_count,
       concat(round(count(*) * 100.0 / SUM (COUNT (*)) OVER (), 2), '%') AS percentage_total
FROM play_store_apps
GROUP BY category
ORDER BY category_count DESC
LIMIT 5;

/* Analysis for most popular category in the Android Play Store.
   Conclusion: Almost 20% of Android Play App apps are in the 'Family' category 
   with 'Game' constituting about 11%, together these categories make up almost 30%
   of Android Play Store's consumer market.
*/
SELECT category,
       count(category) AS category_count,
       concat(round(count(*) * 100.0 / SUM (COUNT (*)) OVER (), 2), '%') AS percentage_total
FROM play_store_apps
GROUP BY category
ORDER BY category_count DESC
LIMIT 5;
