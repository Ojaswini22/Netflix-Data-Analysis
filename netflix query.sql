select * from netflix;

select count(*) as total_content
from netflix;

--1. Count the number of tv shows and movies.

select 
  type ,
  count(*) as total_number
from netflix
group by type

--2. Find the most common ratings for movies and tv shows.

select
  type,
  rating
from
  (select 
      type,
      rating,
      count(*),
      rank() over(partition by type order by count(*) desc) as ranking
   from netflix
   group by 1,2) as t1
where
   ranking=1

--3. List all movies released in specific year.

select *
from netflix
where 
   release_year=2020
   and
   type='Movie'

--4.Find the top 5 countries with most content on netflix.

select 
 unnest(string_to_array(country,','))as new_country,
 count(show_id) as total_content
from netflix
group by 1
order by total_content desc
limit 5

--5. Identify the longest movie.

select *
from netflix
where
  type='Movie'
  and
  duration= (select max(duration) from netflix)

--6. Find the content that added in the last five years.

select *
from netflix
where
    to_date(date_added,'Month DD,YYYY')>= current_date -interval '5 years'

--7. Find the all movies and tv shows directed by 'Rajiv Chilaka'

select *
from netflix
where
   director like '%Rajiv Chilaka%'

--8. List all tv shows with more than 5 season.

select *
from netflix
where
  type='TV Show'
  and
  split_part(duration, ' ',1)::numeric >5

--9. Count the number of content item in each genre.

select 
 unnest(string_to_array(listed_in, ',')) as genre,
 count(show_id)
from netflix
group by 1

--10. Find each year and average number of  content released by india on netflix. Return top 5 year with highest avg content release.


select 
   extract(year from to_date(date_added,'Month DD,YYYY')) as year,
   count(*),
   count(*)::numeric/(select count(*) from netflix where country='India')::numeric*100
from netflix
where
  country='India'
group by 1

--11. List all movies that are documentries.

select *
from netflix
where
  listed_in like '%Documentaries%'

--12. Find all the movies without director.

select *
from netflix
where
   director is null

--13. Find how many movies actor 'Adam Sandler' appeared in last 10 years.

select *
from netflix
where 
casts like '%Adam Sandler%'
and
release_year>extract(year from current_date)-10

--14. Find the top 10 actors who appeared in the highest number of  movies produced in india.

select 
unnest(string_to_array(casts,',')) as actors,
count(*) as total_content
from netflix
where
country like '%India%'
group by 1
order by 2 desc
limit 10

15. Categorize the content based on the presence of keywards 'Kill' and 'Violence' in the description field. 
    label containing these words as 'Bad' and all other as good. count how many content fall into each category.

with new_table
as
(
select 
*,
 CASE
 When 
    description like '%kill%' or
    description like '%Violence%' then 'Bad_content'
    Else 'Good_content'
 end category
from netflix
)
select
  category,
  count(*) as total_content
from new_table
group by 1
