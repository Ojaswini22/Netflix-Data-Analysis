# Netflix Movies and Tv shows Data Analysis using Sql
![netflix logo](https://github.com/Ojaswini22/Netflix-Data-Analysis/blob/main/580b57fcd9996e24bc43c529.png)
## Objective
(1.) Analyze the distribution of content types (movies vs TV shows).

(2.) Identify the most common ratings for movies and TV shows.

(3.) List and analyze content based on release years, countries, and durations.

(4.) Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:[here](https://www.kaggle.com/datasets/shivamb/netflix-shows)

## Schema

```sql

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```
## Business Problems

```sql
SELECT * FROM netflix;

SELECT COUNT(*) as total_content
FROM netflix;
```
1. Count the number of tv shows and movies.

```sql
SELECT 
  type ,
  COUNT(*) as total_number
FROM netflix
GROUP BY type
```
2. Find the most common ratings for movies and tv shows.
```sql
SELECT
  type,
  rating
FROM
  (SELECT
      type,
      rating,
      COUNT(*),
      RANK() over(partition by type order by count(*) desc) as ranking
   FROM netflix
   GROUP BY 1,2) as t1
WHERE
   ranking=1
```

3. List all movies released in specific year.

```sql
SELECT *
FROM netflix
WHERE 
   release_year=2020
   AND
   type='Movie'
```
4.Find the top 5 countries with most content on netflix.

```sql
SELECT 
 UNNEST(string_to_array(country,','))as new_country,
 COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY total_content DESC
LIMIT 5
```

5. Identify the longest movie.

```sql
SELECT *
FROM netflix
WHERE
  type='Movie'
  AND
  duration= (select max(duration) from netflix)
  ```

6. Find the content that added in the last five years.

```sql
SELECT *
FROM netflix
WHERE
    to_date(date_added,'Month DD,YYYY')>= CURRENT_DATE-interval '5 years'
```

7. Find the all movies and tv shows directed by 'Rajiv Chilaka'

```sql

SELECT *
FROM netflix
WHERE
   director LIKE '%Rajiv Chilaka%'
   ```

8. List all tv shows with more than 5 season.

```sql
SELECT *
FROM netflix
WHERE
  type='TV Show'
  AND
  split_part(duration, ' ',1)::numeric >5
  ```

9. Count the number of content item in each genre.
```sql
SELECT 
 UNNEST(string_to_array(listed_in, ',')) as genre,
 COUNT(show_id)
FROM netflix
GROUP BY 1
```
10. Find each year and average number of  content released by india on netflix. Return top 5 year with highest avg content release.

```sql
SELECT 
   EXTRACT(YEAR FROM to_date(date_added,'Month DD,YYYY')) as year,
   COUNT(*),
   COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country='India')::numeric*100
FROM netflix
WHERE
  country='India'
GROUP BY 1
```
11. List all movies that are documentries.
```sql
SELECT *
FROM netflix
WHERE
  listed_in LIKE '%Documentaries%'
```
12. Find all the movies without director.
```sql
SELECT *
FROM netflix
WHERE
   director IS NULL
```
13. Find how many movies actor 'Adam Sandler' appeared in last 10 years.
```sql
SELECT *
FROM netflix
WHERE 
casts LIKE '%Adam Sandler%'
AND
release_year>EXTRACT(YEAR FROM CURRENT_DATE)-10
```
14. Find the top 10 actors who appeared in the highest number of  movies produced in india.
```sql
SELECT 
UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE
country LIKE'%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
```
15. Categorize the content based on the presence of keywards 'Kill' and 'Violence' in the description field. 
    label containing these words as 'Bad' and all other as good. count how many content fall into each category.
```sql
WITH new_table
AS
(
SELECT
*,
 CASE
 WHEN 
    description LIKE '%kill%' OR
    description LIKE '%Violence%' THEN 'Bad_content'
    ELSE 'Good_content'
END category
FROM netflix
)
SELECT
  category,
  COUNT(*) AS total_content
FROM new_table
GROUP BY 1

## Finding and Conclusion

1. Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.

2. Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.

3. Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.

4. Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.


