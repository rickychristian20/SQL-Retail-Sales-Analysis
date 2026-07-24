=================================================
Exploratory Data Analysis (EDA)
Project  : retail.sales
Author   : Ricky Christian
Database : PostgreSQL
Dataset  : retail.sales
Purpose  : Analyze sales performance, customer behavior,
           and product performance using SQL.
=================================================

=================================================
KPI
=================================================

--1.total_order
    SELECT 
	    COUNT(order_id) total_order
	FROM retail.sales;

--2.total_customer 
    SELECT 
	    COUNT(DISTINCT(customer_id)) total_customer
    FROM retail.sales;

--3.total_quantity
    SELECT 
        SUM(quantity) total_quantity
    FROM retail.sales;

--4.total_profit
    SELECT 
	    SUM(profit) total_profit
	FROM retail.sales;

--5.average_customer_rating
    SELECT
        ROUND(AVG(customer_rating),1) AS avg_customer_rating
    FROM retail.sales;

--6.average_discount_percent
    SELECT
	    ROUND(AVG(discount_percent)) avg_discount_percent
    FROM retail.sales;

--7.total_sales
    SELECT
	    ROUND(SUM(total_amount)) total_sales
    FROM retail.sales;

--8.total_returned_and_not_returned
    SELECT
        COUNT(order_id) total_order,
        COUNT(CASE WHEN returned = 'Yes' THEN 1 END) total_returned,
        COUNT(CASE WHEN returned = 'No' THEN 1 END)  total_not_returned
    FROM retail.sales;

=================================================
Time_Analyst
=================================================

--1.total_amount_by_days
    SELECT
        TO_CHAR(order_date,'Day') days_name,
        ROUND(SUM(total_amount)) total_sales
    FROM retail.sales
    GROUP BY 1, EXTRACT(ISODOW FROM order_date)
    ORDER BY EXTRACT(ISODOW FROM order_date);

*Insight*
    - Thursday recorded the highest total sales .
    - Tuesday recorded the lowest total sales.

--2. total_quantity_by_days
    SELECT
        TO_CHAR(order_date,'Day') days_name,
        SUM(quantity) total_quantity
    FROM retail.sales
    GROUP BY 1, EXTRACT(ISODOW FROM order_date)
    ORDER BY EXTRACT(ISODOW FROM order_date);
*Insight*
    - Thursday recorded the highest total quantity.
    - Tuesday recorded the lowest total quantity.

3. total_orders_by_days
    SELECT
        TO_CHAR(order_date,'Day') days_name,
        ROUND(COUNT(order_id)) total_orders
    FROM retail.sales
    GROUP BY 1, EXTRACT(ISODOW FROM order_date)
    ORDER BY EXTRACT(ISODOW FROM order_date);
*Insight*
    - Thursday recorded the highest total orders.
    - Tuesday recorded the lowest total orders.

--4.total_amount_by_month
    SELECT
        TO_CHAR(order_date,'Month') month_name,
        ROUND(SUM(total_amount)) total_sales
    FROM retail.sales
    GROUP BY 1, EXTRACT(MONTH FROM order_date)
    ORDER BY EXTRACT(MONTH FROM order_date);

*Insight*
    - August recorded the highest total sales.
    - February recorded the lowest total sales.

--5.total_quantity_by_month
    SELECT
        TO_CHAR(order_date,'Month') month_name,
        ROUND(SUM(quantity)) total_quantity
    FROM retail.sales
    GROUP BY 1, EXTRACT(MONTH FROM order_date)
    ORDER BY EXTRACT(MONTH FROM order_date);
*Insight*
    - August recorded the highest total quantity.
    - February recorded the lowest total quantity.

6.total_orders_by_month
    SELECT
        TO_CHAR(order_date,'Month') month_name,
        ROUND(COUNT(order_id)) total_orders
    FROM retail.sales
    GROUP BY 1, EXTRACT(MONTH FROM order_date)
    ORDER BY EXTRACT(MONTH FROM order_date);
*Insight*
    - August recorded the highest total orders.
    - February recorded the lowest total orders.    

--7.total_amount_by_year
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        ROUND(SUM(total_amount)) total_sales
    FROM retail.sales
    GROUP BY 1
    ORDER BY 1;
*Insight*
    - 2025 has the highest total sales.
    - 2024 has the lowest total sales.

--8.total_quantity_by_year
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        ROUND(SUM(quantity)) total_quantity
    FROM retail.sales
    GROUP BY 1
    ORDER BY 1;
*Insight*
    - 2025 has the highest total quantity.
    - 2024 has the lowest total quantity.

--9.total_profit_by_year
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        ROUND(SUM(profit)) total_profit
    FROM retail.sales
    GROUP BY 1
    ORDER BY 1;

*Insight*
   - 2025 recorded the highest profit, followed by 2024 and 2026.

--10.Total_order_by_year
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        COUNT(order_id) total_orders
    FROM retail.sales
    GROUP BY 1
    ORDER BY 1;
*Insight*
   - 2025 recorded the highest total_orders, followed by 2024 and 2026.

=================================================
Product_Analyst
=================================================

--1.Top_product_by_total_amount
    SELECT
        product,
        ROUND(SUM(total_amount)) total_amount
    FROM retail.sales
    GROUP BY 1
    ORDER BY 2 DESC;

*Insight*
    - Laptop recorded the highest total amount.
    - Mouse recorded the lowest total amount.

--2.top_product_by_quantity
    SELECT
        DISTINCT(product),
        SUM(quantity) total_quantity
    FROM retail.sales
    GROUP BY 1
    ORDER BY 2 DESC;

*Insight*
    - Washing Machine recorded the highest total quantity.
    - SSD recorded the lowest total quantity

--3. top_product_by_orders
    SELECT
        DISTINCT(product),
        COUNT(order_id) total_orders
    FROM retail.sales
    GROUP BY 1
    ORDER BY 2 DESC;

*Insight*
    - Keyboard recorded the highest number of orders.
    - Camera recorded the lowest number of orders.

--4. top_profit_by_product
    SELECT
        DISTINCT(product),
        ROUND(SUM(profit)) profit
    FROM retail.sales
    GROUP BY 1
    ORDER BY 2 DESC ;

*Insight*
    - Laptop recorded the highest profit.
    - Mouse recorded the lowest profit.

--5.Top Profit Product by State
    WITH profit_state AS (
        SELECT
            state,
            product,
            ROW_NUMBER() OVER (PARTITION BY state 
                                ORDER BY SUM(profit) DESC ) tp,
        SUM(profit) total_profit
        FROM retail.sales
        GROUP BY 1,2
    ) 
		SELECT
			state,
			product,
			ROUND(total_profit)
		FROM profit_state
		WHERE tp = 1   
		ORDER BY total_profit DESC;

*Insight*
    -- Laptop was the top-profit product in the highest number of states.

--6. Top_quantity_product_by_state
    WITH quantity_state AS (
        SELECT
            state,
            product,
            ROW_NUMBER() OVER (PARTITION BY state ORDER BY SUM(quantity) DESC ) tq,
        SUM(quantity) total_quantity
        FROM retail.sales
        GROUP BY 1,2
    ) 
            SELECT
                state,
                product,
                total_quantity
            FROM quantity_state
            WHERE tq = 1
            ORDER BY total_quantity DESC;
*Insight*
    - Tamil Nadu recorded the highest quantity with the Refrigerator product across all states.
    - West Bengal recorded the lowest quantity with the Monitor product across all states

--7. Top orders product by state
    WITH orders_state AS (
        SELECT
            state,
            product,
            ROW_NUMBER() OVER (PARTITION BY state ORDER BY COUNT(order_id) DESC ) tos,
        COUNT(order_id) total_orders
        FROM retail.sales
        GROUP BY 1,2
    ) 
            SELECT
                state,
                product,
                total_orders
            FROM orders_state
            WHERE tos = 1
            ORDER BY total_orders DESC;
*Insight*
    - Maharashtra recorded the highest orders  with the Keyboard product across all states.
    - West Bengal recorded the lowest orders with the Bookshelf product across all states.

--8. 5 Top Product by Profit
        SELECT
        product,
        ROUND(SUM(profit)) total_profit
    FROM retail.sales	
    GROUP BY 1
    ORDER BY 2 DESC 
    LIMIT 5;

*Insight*
    - Laptop recorded the highest profit.

--9. Average Orders Product By year
    WITH avg_ AS (
    SELECT
        product,
        COUNT(order_id) total_order,
        EXTRACT(YEAR FROM order_date) AS year
    FROM retail.sales	
    GROUP BY 1,3
    ORDER BY 3
    )
        SELECT 
        product,
        ROUND(AVG(total_order)) avg_orders
        FROM avg_
        GROUP BY 1
        ORDER BY 2 DESC;

*Insight*
    - Keyboard recorded the highest average product by year.
    - Camera recorded the lowest average product by year.

=================================================
Category_Analyst
=================================================    

--1.total amount by category
    SELECT
        category,
        ROUND(SUM(total_amount)) total_amount
    FROM retail.sales
    GROUP BY 1
    ORDER BY 2 DESC;

*Insight*    
   - Electronics recorded the highest total amount.
   - Accessories recorded the lowest total amount.

--2. total orders by category
    SELECT
        category,
        COUNT(order_id) total_orders
    FROM retail.sales
    GROUP BY 1
    ORDER BY 2 DESC;

*Insight*
    - Electronics recorded the highest total orders.
    - Office recorded the lowest total orders.

--3. Returned Orders and Average Customer Rating by Category
    SELECT
        category,
        ROUND(AVG(customer_rating),2) average_customer_rating,
        COUNT(returned) total_returned
    FROM retail.sales
    WHERE returned = 'Yes'
    GROUP BY 1
    ORDER BY 3 DESC;

*Insight*
    - Electronics recorded the highest number of product returns, with 6,362 returned items and 
      an average customer rating of 3.01, making it the category with the largest contribution to total returns

    =================================================
    Customer_Analyst
    =================================================  

    --1. Top 10 Customers by Total amount and Profit
        SELECT
            customer_name,
            ROUND(SUM(total_amount)) total_amount,
            ROUND(SUM(profit)) total_profit
        FROM retail.sales
        GROUP BY 1
        ORDER BY 2 DESC 
        LIMIT 10;

    *Insight*
        -Yatin Issac recorded the highest total sales of 536.120, generating a total profit of 86.330, 
        making them the company is largest total amount contributor.

    --2. total customer,total amount and profit by gender.
        SELECT
            gender,
            COUNT(customer_id) total_customer,
            ROUND(SUM(total_amount)) total_amount,
            ROUND(SUM(profit)) total_profit
        FROM retail.sales
        GROUP BY 1
        ORDER BY 4 DESC;

    *Insight*
        - Male customers generated the highest total sales (1,179,467,115) 
        and the highest total profit (202,289,627).

    --3.Total Repeat and new customer
        WITH customer_orders AS (
            SELECT
                customer_id,
                COUNT(order_id) total_orders
            FROM retail.sales
            GROUP BY 1
        )
        SELECT
            CASE 
            WHEN total_orders = 1 THEN 'New Customer'
            ELSE 'Repeat Customer'
        END AS customer_type,
            COUNT(customer_id) total_customer
        FROM customer_orders
        GROUP BY customer_type;

    *Insight*
        - Repeat customers accounted for 8,741 customers, 
        indicating that the vast majority of customers made more than one purchase.
        
    --4. Customer Performance by Age Group
        SELECT
            CASE
                WHEN age BETWEEN 17 AND 19 THEN '17-19'
                WHEN age BETWEEN 20 AND 29 THEN '20-29'
                WHEN age BETWEEN 30 AND 39 THEN '30-39'
                WHEN age BETWEEN 40 AND 49 THEN '40-49'
                WHEN age BETWEEN 50 AND 59 THEN '50-59'
                ELSE '60+'
            END AS customer_age,
                COUNT(DISTINCT(customer_id)) total_customer,
                COUNT(order_id) total_orders,
                SUM(quantity) quantity,
                ROUND(SUM(total_amount)) total_sales,
                ROUND(SUM(profit)) total_profit
        FROM retail.sales
        GROUP BY customer_age
        ORDER BY total_profit DESC;
    *Insight*
        - Customers aged 30–39 generated the highest total sales (495.279.260) 
        and total profit (84.901.830), making them the most valuable customer segment. 
        They also recorded 10.484 orders from 6.148 customers, 
        indicating strong purchasing activity and a significant contribution to the company is overall revenue.

=================================================
    Sales_Analyst
================================================= 

--1.Total Profit by Customer and State
    WITH customer_method AS (
        SELECT
            state,
            customer_name,
            COUNT(order_id) total_order,
            SUM(quantity) quantity,
            ROUND(SUM(total_amount)) total_amount,
            ROUND(SUM(profit)) total_profit,
            ROW_NUMBER() OVER(PARTITION BY state ORDER BY SUM(profit) DESC) rw
        FROM retail.sales
        GROUP BY state,customer_name
        )
        SELECT
            state,
            customer_name,
            total_order,
            quantity,
            total_amount,
            total_profit
        FROM customer_method
        WHERE rw = 1
        ORDER BY total_profit DESC;

--2.Payment Method Performance by State
    WITH customer_payment AS (
        SELECT
            payment_method,
            state,
            COUNT(order_id) total_orders,
            ROUND(SUM(total_amount)) total_amount,
            ROUND(SUM(profit)) total_profit,
            ROW_NUMBER() OVER(PARTITION BY state ORDER BY SUM(profit) DESC) rw
        FROM retail.sales
        GROUP BY payment_method,state
        ORDER BY SUM(profit) DESC
    )
        SELECT
            state,
            payment_method,
            total_orders,
            total_amount,
            total_profit
        FROM customer_payment
        WHERE rw = 1;

--3.Order Return Analysis by State
    SELECT
        state,
        COUNT(order_id) total_orders,
        COUNT(CASE WHEN returned = 'Yes' THEN 1 END) returned,
        COUNT(CASE WHEN returned = 'No' THEN 1 END) no_returned,
        ROUND(
            COUNT(CASE WHEN returned = 'Yes' THEN 1 END) * 100.0 /
            COUNT(order_id), 2
        ) AS return_rate_pct
    FROM retail.sales
    GROUP BY 1
    ORDER BY return_rate_pct DESC;

*Insight*
    - Karnataka had the highest return rate (51.39%), with more than half of its orders being returned, 
      indicating a potential need to improve product quality or customer satisfaction.
