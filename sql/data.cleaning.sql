-- ============================================
-- Project  : Retail Sales Analysis
-- File     : 01_Data_Cleaning.sql
-- Database : PostgreSQL
-- Author   : Ricky Simatupang
-- ============================================

-- ============================================
-- DATA CLEANING
-- ============================================
    
--1. Chek NULL --
    SELECT
	*
    FROM retail.sales
    WHERE customer_id IS NULL
        OR order_id IS NULL
        OR customer_name IS NULL
        OR age IS NULL
        OR payment_method IS NULL
        OR profit IS NULL;

--2. Chek Duplicate
    SELECT
        order_id,
        COUNT(*) AS total_duplicate
    FROM retail.sales
    GROUP BY order_id
    HAVING COUNT(*) > 1;

    SELECT
        customer_id,
        COUNT(*) AS total_duplicate
    FROM retail.sales
    GROUP BY order_id
    HAVING COUNT(*) > 1;

--3. Check Text Consistency
    
    SELECT 
        DISTINCT gender
    FROM retail.sales;

    SELECT 
        DISTINCT customer_name
    FROM retail.sales;

    SELECT 
        DISTINCT category
    FROM retail.sales;