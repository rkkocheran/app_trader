### App Trader

Your team has been hired by a new company called App Trader to help them explore and gain insights from apps that are made available through the Apple App Store and Android Play Store. App Trader is a broker that purchases the rights to apps from developers in order to market the apps and offer in-app purchase. App developers retain **all** money from users purchasing the app, and they retain _half_ of the money made from in-app purchases. App Trader will be solely responsible for marketing apps they purchase rights to.  

Unfortunately, the data for Apple App Store apps and Android Play Store Apps is located in separate tables with no referential integrity.

#### 1. Loading the data
a. Launch PgAdmin and create a new database called app_trader.  

b. Right-click on the app_trader database and choose `Restore...`  

c. Use the default values under the `Restore Options` tab.

d. In the `Filename` section, browse to the backup file `app_store_backup.backup` in the data folder of this repository.  

e. Click `Restore` to load the database.  

f. Verify that you have two tables:  
    - `app_store_apps` with 7197 rows  
    - `play_store_apps` with 10840 rows


#### 2. Assumptions
Based on research completed prior to launching App Trader as a company, you can assume the following:  

a. App Trader will purchase apps for 10,000 times the price of the app, however the minimum price to purchase an app is $25,000.  For example, a $3 app would cost $30,000 (10,000 x the price) and a free app would cost $25,000 (The minimum price).  NO APP WILL EVER COST LESS THEN $25,000 TO PURCHASE.  

b. Apps earn $5000 per month on average from in-app advertising and in-app purchases _regardless_ of the price of the app.  

c. App Trader will spend an average of $1000 per month to market an app _regardless_ of the price of the app. If App Trader owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month.  

d. For every quarter-point that an app gains in rating, its projected lifespan increases by 6 months, in other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years. Ratings should be rounded to the nearest 0.25 to evaluate an app's likely longevity.  

e. App Trader would prefer to work with apps that are available in both the App Store and the Play Store since they can market both for the same $1000 per month.

#### 3. Deliverables
a. Develop some general recommendations as to the price range, genre, content rating, or anything else for apps that the company should target.  

b. Develop a Top 10 List of the apps that App Trader should buy next week for its **Halloween** debut.  

c. Submit a report based on your findings.  The report should include the 10 apps which would have the highest return on investment.  Also, select 5 profitable apps
which fit the theme; also include their cost and potential profits.



### All analysis work must be done in PostgreSQL, however you may export query results to create charts in Excel for your report.
