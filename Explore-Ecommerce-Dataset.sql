--Q1: Calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)

SELECT format_date('%Y%m',parse_date('%Y%m%d',date)) as month,
       sum(totals.visits) as visits,
       sum(totals.pageviews) as pageviews,
       sum(totals.transactions) as transactions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE _table_suffix BETWEEN '0101' AND '0331'
GROUP BY 1
ORDER BY 1;

--Q2: Bounce rate per traffic source in July 2017 (Bounce_rate = num_bounce/total_visit) (order by total_visit DESC)

SELECT trafficSource.source,
       sum(totals.visits) as visits,
       sum(totals.bounces) as total_no_of_bounces,
       (sum(totals.bounces)/sum(totals.visits))*100.0 as bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
GROUP BY 1
ORDER BY 2 DESC;

--Q3: Revenue by traffic source by week, by month in June 2017

WITH month as(
SELECT 'Month' as time_type
       ,format_date('%Y%m',parse_date('%Y%m%d',date)) as time
       ,trafficSource.source
       ,round((sum(productRevenue)/1000000),2) as revenue,
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
       UNNEST (hits) as hits,
       UNNEST (hits.product) as product
WHERE productRevenue is not null
GROUP BY 1, 2, 3
ORDER BY 4)
,
week as (SELECT 'Week' as time_type
       ,format_date('%Y%W',parse_date('%Y%m%d',date)) as time
       ,trafficSource.source
       ,round((sum(productRevenue)/1000000),2) as revenue
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
       UNNEST (hits) hits,
       UNNEST (hits.product) product
WHERE productRevenue is not null
GROUP BY 1,2,3
ORDER BY 4)

SELECT *
FROM month
UNION ALL
SELECT *
FROM week
ORDER BY revenue DESC;

--Q4: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.

WITH purchaser_data as(
  select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      sum(totals.pageviews)/count(distinct fullvisitorid) as avg_pageviews_purchase,
  from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`    
      , UNNEST(hits) AS hits
      , UNNEST(hits.product) AS product
  where _table_suffix BETWEEN '0601' AND '0731'
        and totals.transactions >=1
        and productRevenue is not null
  group by month
),

non_purchaser_data as(
   select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      sum(totals.pageviews)/count(distinct fullVisitorId) as avg_pageviews_non_purchase,
   from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
      , UNNEST(hits) AS hits
      , UNNEST(hits.product) AS product
   where _table_suffix BETWEEN '0601' AND '0731'
        and totals.transactions is null
        and productRevenue is  null
   group by month
)

select
    month,
    avg_pageviews_purchase,
    avg_pageviews_non_purchase
from purchaser_data 
full join non_purchaser_data using(month)
order by month;

--Q5:Average number of transactions per user that made a purchase in July 2017

SELECT 
       format_date('%Y%m',parse_date('%Y%m%d',date)) as Month
      ,round(sum(totals.transactions)/count(distinct fullVisitorId),9) as Avg_total_transactions_per_user
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
      , UNNEST (hits) as hits
      , UNNEST (hits.product) as product
WHERE  totals.transactions >=1 and product.productRevenue is not null
GROUP BY 1;

--Q6: Average amount of money spent per session. Only include purchaser data in July 2017

SELECT  format_date('%Y%m',parse_date('%Y%m%d',date)) as Month
     ,  (sum(product.productRevenue)/sum(totals.visits))/1000000 as avg_revenue_by_user_per_visit
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
      , UNNEST (hits) hits
      , UNNEST (hits.product) product
WHERE totals.transactions is not null
   and product.productRevenue is not null 
GROUP BY 1;

--Q7: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.

SELECT v2ProductName as other_purchased_products
       ,sum(productQuantity) as quantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
              ,UNNEST (hits) hits
              ,UNNEST (hits.product) product
WHERE product.productRevenue is not null 
  and fullVisitorid in (SELECT fullVisitorid
                      FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
                          , UNNEST (hits) hits
                          , UNNEST (hits.product) product
                      WHERE v2ProductName = "YouTube Men's Vintage Henley"
                        and product.productRevenue is not null)
  and v2ProductName != "YouTube Men's Vintage Henley"                     
GROUP BY 1
ORDER BY 2 DESC;

--Q8: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017

WITH A as (SELECT 
      format_date('%Y%m',parse_date('%Y%m%d',date)) as Month
      , COUNT (CASE WHEN  hits.eCommerceAction.action_type = '2' THEN 1 END) as num_product_view
      , COUNT (CASE WHEN  hits.eCommerceAction.action_type = '3' THEN 1 END) as num_addtocart
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
, UNNEST (hits) hits
, UNNEST (hits.product) product
WHERE _table_suffix BETWEEN '0101' AND '0331'
GROUP BY 1
ORDER BY 1)

,B as (SELECT 
       format_date('%Y%m',parse_date('%Y%m%d',date)) as Month
       , COUNT (CASE WHEN  hits.eCommerceAction.action_type = '6' THEN 1 END) as num_purchase
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
, UNNEST (hits) hits
, UNNEST (hits.product) product
WHERE _table_suffix BETWEEN '0101' AND '0331' and product.productRevenue is not null
GROUP BY 1
ORDER BY 1)

SELECT Month
       ,num_product_view
       ,num_addtocart
       ,num_purchase
       ,round((num_addtocart/num_product_view)*100.0,2) as add_to_cart_rate
       ,round((num_purchase/num_product_view)*100.0,2) as purchase_rate
FROM A
FULL JOIN B 
USING (Month)
ORDER BY 1;

-- Solution 2:
with product_data as(
select
    format_date('%Y%m', parse_date('%Y%m%d',date)) as month,
    count(CASE WHEN eCommerceAction.action_type = '2' THEN product.v2ProductName END) as num_product_view,
    count(CASE WHEN eCommerceAction.action_type = '3' THEN product.v2ProductName END) as num_add_to_cart,
    count(CASE WHEN eCommerceAction.action_type = '6' and product.productRevenue is not null THEN product.v2ProductName END) as num_purchase
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
,UNNEST(hits) as hits
,UNNEST (hits.product) as product
where _table_suffix between '20170101' and '20170331'
and eCommerceAction.action_type in ('2','3','6')
group by month
order by month
)

select
    *,
    round(num_add_to_cart/num_product_view * 100, 2) as add_to_cart_rate,
    round(num_purchase/num_product_view * 100, 2) as purchase_rate
from product_data;







