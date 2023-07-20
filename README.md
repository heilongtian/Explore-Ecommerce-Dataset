**[SQL] Explore Ecommerce Dataset**

**I. Introduction**
This project contains an E-commerce dataset on Google BigQuery that I used SQL to explore it. The dataset is based on the Google Analytics public dataset and contains data from an E-commerce website.

**II. Requirements**
Google Cloud Platform account
Project on Google Cloud Platform
Google BigQuery API enabled
SQL query editor or IDE

**III. Dataset Access**
The E-commerce dataset is stored in a public Google BigQuery dataset. To access the dataset, follow these steps:

- Log in to your Google Cloud Platform account and create a new project
- Navigate to the BigQuery console and select your newly created project
- In the navigation panel, select "Add Data" and then "Search a project"
- Enter the project ID "bigquery-public-data.google_analytics_sample.ga_sessions" and click "Enter"
- Click on the "ga_sessions_" table to open it

**IV. Exploring the Dataset**

**Question 1: Calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)**

![image](https://github.com/heilongtian/Explore-Ecommerce-Dataset/assets/126595334/d37484ab-fedf-4ed5-bbcb-44167507663c)

Result

![image](https://github.com/heilongtian/Explore-Ecommerce-Dataset/assets/126595334/dee826eb-9bc0-4ec8-b432-9ed9e413c8ef)

**Question 2: Bounce rate per traffic source in July 2017**

![image](https://github.com/heilongtian/Explore-Ecommerce-Dataset/assets/126595334/378b20dd-1a27-44f9-b3d6-2baaf885147f)

Result

![image](https://github.com/heilongtian/Explore-Ecommerce-Dataset/assets/126595334/ecd8194c-fd37-4aa5-9b08-fed8efcda876)

**Question 3: Revenue by traffic source by week, by month in June 2017**

![image](https://github.com/heilongtian/Explore-Ecommerce-Dataset/assets/126595334/4c3216cf-be84-4406-84d2-b5a6d06f091d)

Result

![image](https://github.com/heilongtian/Explore-Ecommerce-Dataset/assets/126595334/efcf1ce0-9141-4eed-b86a-b59bb3159545)

**Question 4: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017**

![image](https://github.com/heilongtian/Explore-Ecommerce-Dataset/assets/126595334/3f3a1d23-ce44-4ae8-9f66-4af799fd77fe)

Result

![image](https://github.com/heilongtian/Explore-Ecommerce-Dataset/assets/126595334/624e6af4-bc7b-49c4-9b4c-5fa0c0b1dff8)

**Question 5:Average number of transactions per user that made a purchase in July 2017**

![image](https://github.com/heilongtian/Explore-Ecommerce-Dataset/assets/126595334/80acd1cd-f59c-46e9-8eff-3819c7d03998)

Result

![image](https://github.com/heilongtian/Explore-Ecommerce-Dataset/assets/126595334/e225d373-e2c2-4cf2-b464-76ac3f9adfd5)

Question 6: Average amount of money spent per session. Only include purchaser data in July 2017

![image](https://github.com/heilongtian/Explore-Ecommerce-Dataset/assets/126595334/142df038-8e75-4d9e-9e20-226639dff468)

Result

![image](https://github.com/heilongtian/Explore-Ecommerce-Dataset/assets/126595334/d71d68ac-f8e1-4fa7-9f08-e498b16599d4)

**Question 7: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered**

![image](https://github.com/heilongtian/Explore-Ecommerce-Dataset/assets/126595334/5be181ac-c258-49e4-9959-d81673f18271)

Result

![image](https://github.com/heilongtian/Explore-Ecommerce-Dataset/assets/126595334/bf533b4a-3eeb-4d12-8c4b-14456bf89fc6)

**Question 8: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017**

#Solution 1

![image](https://github.com/heilongtian/Explore-Ecommerce-Dataset/assets/126595334/07eab243-ab04-4109-836e-c19c053e7a0e)

#Solution 2

![image](https://github.com/heilongtian/Explore-Ecommerce-Dataset/assets/126595334/057ba413-1d10-4f1e-845e-e2334bedec6b)

Result

![image](https://github.com/heilongtian/Explore-Ecommerce-Dataset/assets/126595334/033e1ff3-42cd-4cc6-b69f-ed0c2edff45b)

