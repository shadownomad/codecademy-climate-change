-- Understanding the data
--1. 
SELECT *
FROM state_climate; --standard familiarization query

--Aggregate and Value Functions
--2
SELECT state, 
       year,
       tempf,
       AVG(tempf) over(
          PARTITION BY state
          ORDER BY YEAR
       ) AS running_avg_temp --reurns averate tempf per state.
FROM state_climate;
--3
SELECT state,
       year,
       tempf,
       FIRST_VALUE(tempf) OVER(
          PARTITION BY state
          ORDER BY tempf
       ) AS lowest_temp --returns lowest temp per state
FROM state_climate;
--4
SELECT state,
       year,
       tempf,
       LAST_VALUE(tempf) OVER(
          PARTITION BY state
          ORDER BY tempf
          RANGE BETWEEN UNBOUNDED PRECEDING AND 
      UNBOUNDED FOLLOWING -- avoids returning just the entry of current column
       ) AS highest_temp -- returns highjest temp per state
FROM state_climate;
--5
SELECT state,
      year,
      tempf,
      tempf - LAG(tempf, 1, tempf) OVER(
          PARTITION BY state
          ORDER BY year
      )AS change_in_temp --shows the difference in tempf per year by state
FROM state_climate;
-- Ranking Functions
--6.
SELECT RANK()OVER (
  ORDER BY tempf
  ) as coldest_rank, --ranks by the coldest entries
  year,
  state,
  tempf
FROM state_climate;
--7
SELECT RANK()OVER (
     PARTITION BY state -- sorts by state
     ORDER BY tempf DESC -- ranks by warmest entry
  ) as warmest_rank,
  year,
  state,
  tempf
FROM state_climate; 
--8
SELECT NTILE(4) OVER(
    PARTITION BY state
    ORDER BY tempf
) AS quartile, --returns quartile per state by lowest tempf
  year,
  state,
  tempf
FROM state_climate;

--9
SELECT NTILE(5) OVER (
  ORDER BY tempf
) AS quintile, -- returns quintile by lowest tempf
  year,
  state,
  tempf
FROM state_climate;
