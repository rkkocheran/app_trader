/* Project: App Trader Data Analysis
   Project Team: Almond Joy */

/* Analysis for most popular content_rating in the Android Play Store.
   Conclusion: Over 80% of Android Play App Customers are in the 'Everyone' category 
   with 'Teen' constituting about 11%, together these categories make up over 90%
   of Android Play Store's consumer market. */
   
SELECT content_rating,
       round(count(*) * 100.0 / SUM (COUNT (*)) OVER (), 0) AS percentage_total
--FROM distinct_play_table
FROM (SELECT DISTINCT *
       FROM play_store_apps
       ORDER BY name) AS distinct_play_table
GROUP BY content_rating
ORDER BY percentage_total DESC;


/* Analysis for most popular content_rating in the Apple App Store.
   Conclusion: Over 60% of Apple App Customers are in the '4+' category 
   with '12+' constituting about 16%, together these categories make up almost 80%
   of Android Play Store's consumer market. */ 
   
SELECT content_rating,
       round(count(*) * 100.0 / SUM (COUNT (*)) OVER (), 0) AS percentage_total
FROM (SELECT DISTINCT *
       FROM app_store_apps
       ORDER BY name) as distinct_app_table
GROUP BY content_rating
ORDER BY percentage_total DESC;





/* Analysis for most popular category in the Android Play Store.
   Conclusion: Almost 20% of Android Play App apps fall in the 'Family' category 
   with 'Game' constituting about 11%, together these categories make up almost 30%
   of Android Play Store's consumer market. */
   
SELECT category,
       ROUND(COUNT(*) * 100.0 / SUM (COUNT (*)) OVER (), 0) AS percentage_total
FROM (SELECT DISTINCT *
       FROM play_store_apps
       ORDER BY name) AS distinct_play_table
GROUP BY category
ORDER BY percentage_total DESC
LIMIT 5;


/* Analysis for most popular category in the Apple App Store.
   Conclusion: Over 50% of Apple's App Store apps fall in the 'Games' category 
   with 'Entertainment' constituting about 7% of Android Play Store's consumer market. */
   
SELECT primary_genre,
       ROUND(COUNT(*) * 100.0 / SUM (COUNT (*)) OVER (), 0) AS percentage_total
FROM (SELECT DISTINCT *
       FROM app_store_apps
       ORDER BY name) as distinct_app_table
GROUP BY primary_genre
ORDER BY percentage_total DESC
LIMIT 5;





/* Code to establish a temporary table which joins both the app and play store databases, removes unnecessary duplicates
   and adds calucated columns for each distinct app's average price, rating, review_count, and purchase price with a final
   calculated column for apps' estimated lifespan. */
   
WITH distinct_appstores AS (
	SELECT
	 	DISTINCT name,
	 	app_store_apps.price::MONEY AS app_price,
	 	app_store_apps.rating AS app_rating,
	 	app_store_apps.primary_genre AS app_genre,
	 	app_store_apps.review_count::INTEGER AS app_review_count,
	 	app_store_apps.content_rating AS app_content_rating,
	
	 	play_store_apps.price::MONEY AS play_price,
	 	play_store_apps.rating AS play_rating,
	 	play_store_apps.category AS play_genre,
	 	play_store_apps.review_count AS play_review_count,
	 	play_store_apps.content_rating AS play_content_rating,
	
	 	(app_store_apps.price::MONEY + play_store_apps.price::MONEY)/2 AS avg_price,
	 	ROUND(((app_store_apps.rating + play_store_apps.rating)/2)/25,2)*25 AS avg_rating,
	 	(app_store_apps.review_count::INTEGER + play_store_apps.review_count)/2 AS avg_review_count,
	 	2*(ROUND(((app_store_apps.rating + play_store_apps.rating)/2)/25,2)*25)+1 AS lifespan_yrs,
	
	 	CASE WHEN ((app_store_apps.price::MONEY + play_store_apps.price::MONEY)/2)::NUMERIC >=2.5 THEN
	 		(((app_store_apps.price::MONEY + play_store_apps.price::MONEY)/2)::NUMERIC *10000)
	 	ELSE 25000 END AS avg_price_to_purchase
FROM app_store_apps INNER JOIN play_store_apps USING(name))


/* Code for determining the best recommendations for App Trader using the most popular content ratings, genres and price brackets,
   and filtering the results to return the Top-10 most profitable apps based on the calculated fields for net profit over each 
   app's estimated lifespan. */

SELECT DISTINCT(name),
	avg_price,
	avg_rating,
	avg_price_to_purchase::MONEY,
	(avg_price_to_purchase + (1000*(lifespan_yrs*12)))::MONEY AS gross_cost,
	((5000*(lifespan_yrs*12)))::MONEY AS gross_profit,
	(((5000*(lifespan_yrs*12))) - (avg_price_to_purchase + (1000*(lifespan_yrs*12))))::MONEY AS net_profit
FROM distinct_appstores
WHERE avg_price::NUMERIC < 2 AND app_genre ILIKE('%game%') AND play_genre ILIKE('%game%')
	AND app_content_rating = '4+' AND play_content_rating = 'Everyone'
ORDER BY net_profit DESC
LIMIT 10;





/* CTEs for determining a list of top-10 app recommendations for Halloween 
   based on profitability and theme relevance. */

WITH distinct_appstores AS
      (SELECT DISTINCT name,
                       app_store_apps.price::MONEY AS app_price,
                       app_store_apps.rating AS app_rating,
                       app_store_apps.primary_genre AS app_genre,
                       app_store_apps.review_count::INTEGER AS app_review_count,
                       app_store_apps.content_rating AS app_content_rating,
                       play_store_apps.price::MONEY AS play_price,
                       play_store_apps.rating AS play_rating,
                       play_store_apps.category AS play_genre,
                       play_store_apps.review_count AS play_review_count,
                       play_store_apps.content_rating AS play_content_rating,
                       (app_store_apps.price::MONEY + play_store_apps.price::MONEY) / 2 AS avg_price,
                       round(((app_store_apps.rating + play_store_apps.rating) / 2) / 25, 2) * 25 AS avg_rating,
                       (app_store_apps.review_count::INTEGER + play_store_apps.review_count) / 2 AS avg_review_count,
                       2 * (round(((app_store_apps.rating + play_store_apps.rating) / 2) / 25, 2) * 25) + 1 AS lifespan_yrs,
                       CASE
                           WHEN ((app_store_apps.price::MONEY + play_store_apps.price::MONEY) / 2)::NUMERIC >= 2.5 
                           THEN (((app_store_apps.price::MONEY + play_store_apps.price::MONEY) / 2)::NUMERIC * 10000)
                           ELSE 25000
                       END AS avg_price_to_purchase
       FROM app_store_apps
       INNER JOIN play_store_apps USING(name)),

halloween_apps AS
      (SELECT distinct(name),
              avg_price,
              avg_rating,
              (avg_price_to_purchase)::MONEY,
              (avg_price_to_purchase + (1000 * (lifespan_yrs * 12)))::MONEY AS gross_cost,
              ((5000 * (lifespan_yrs * 12)))::MONEY AS gross_profit,
              (((5000 * (lifespan_yrs * 12))) - (avg_price_to_purchase + (1000 * (lifespan_yrs * 12))))::MONEY AS net_profit
       FROM distinct_appstores
       WHERE ((5000 * (lifespan_yrs * 12))) - (avg_price_to_purchase + (1000 * (lifespan_yrs * 12))) > 0
             AND app_genre ilike('%game%')
             AND play_genre ilike('%game%')
             AND name ILIKE '%zombie%'
             OR name ILIKE '%candy%'
             OR name ILIKE '%five%'
             OR name ILIKE '%temple%'
       ORDER BY net_profit DESC)


/* Code to filter for our top-5 Halloween app recommendations using the above two CTEs. */

SELECT *
FROM halloween_apps
WHERE name = 'Zombie Catchers'
      OR name = 'Candy Crush Saga'
      OR name = 'Temple Run'
      OR name = 'Zombie Tsunami'
      OR name = 'Five Nights at Freddy''s';
