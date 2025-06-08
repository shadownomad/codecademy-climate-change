# CodeCademy Climate Change
## Understanding the Data
### 1. Let’s see what our table contains by running the following command:

```SQL
SELECT * 
FROM state_climate;

```

First 10 Results:
| state   | year | tempf       | tempc       |
|---------|------|-------------|-------------|
| Alabama | 1895 | 61.64166667 | 16.46759259 |
| Alabama | 1896 | 64.26666667 | 17.92592593 |
| Alabama | 1897 | 64.19166667 | 17.88425926 |
| Alabama | 1898 | 62.98333333 | 17.21296296 |
| Alabama | 1899 | 63.1        | 17.27777778 |
| Alabama | 1900 | 63.40833333 | 17.44907407 |
| Alabama | 1901 | 61.39166667 | 16.3287037  |
| Alabama | 1902 | 63.58333333 | 17.5462963  |
| Alabama | 1903 | 61.975      | 16.65277778 |
| Alabama | 1904 | 62.76666667 | 17.09259259 |
 

## Aggregate and Value Functions
### 2. Let’s start by looking at how the average temperature changes over time in each state.

>Write a query that returns the state, year, tempf or tempc, and running_avg_temp (in either Celsius or Fahrenheit) for each state.

(The running_avg_temp should use a window function.)

```SQL
SELECT state, 
       year,
       tempf,
       AVG(tempf) over(
          PARTITION BY state
          ORDER BY YEAR
       ) AS running_avg_temp --returns average tempf per state.
FROM state_climate;

```

First 10 Results:
| state   | year | tempf       | running_avg_temp |
|---------|------|-------------|------------------|
| Alabama | 1895 | 61.64166667 | 61.64166667      |
| Alabama | 1896 | 64.26666667 | 62.95416667      |
| Alabama | 1897 | 64.19166667 | 63.36666667      |
| Alabama | 1898 | 62.98333333 | 63.270833335     |
| Alabama | 1899 | 63.1        | 63.236666668     |
| Alabama | 1900 | 63.40833333 | 63.2652777783333 |
| Alabama | 1901 | 61.39166667 | 62.9976190485714 |
| Alabama | 1902 | 63.58333333 | 63.07083333375   |
| Alabama | 1903 | 61.975      | 62.9490740744444 |
| Alabama | 1904 | 62.76666667 | 62.930833334     |

### 3. Now let’s explore the lowest temperatures for each state.
Write a query that returns state, year, tempf or tempc, and the lowest temperature (lowest_temp) for each state.

```SQL
SELECT state,
       year,
       tempf,
       FIRST_VALUE(tempf) OVER(
          PARTITION BY state
          ORDER BY tempf
       ) AS lowest_temp --returns lowest temp per state
FROM state_climate;
```
First 10 Results:
| state   | year | tempf       | lowest_temp |
|---------|------|-------------|-------------|
| Alabama | 1976 | 60.675      | 60.675      |
| Alabama | 1968 | 61.0        | 60.675      |
| Alabama | 1940 | 61.175      | 60.675      |
| Alabama | 1983 | 61.19166667 | 60.675      |
| Alabama | 1958 | 61.21666667 | 60.675      |
| Alabama | 1979 | 61.35833333 | 60.675      |
| Alabama | 1969 | 61.36666667 | 60.675      |
| Alabama | 1901 | 61.39166667 | 60.675      |
| Alabama | 1960 | 61.54166667 | 60.675      |
| Alabama | 1895 | 61.64166667 | 60.675      |

Are the lowest recorded temps for each state more recent or more historic?

>The lowest temps are consistently more historic


### 4. Like before, write a query that returns state, year, tempf or tempc, except now we will also return the highest temperature (highest_temp) for each state.

```SQL
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
```
First 10 results:
| state   | year | tempf       | highest_temp |
|---------|------|-------------|--------------|
| Alabama | 1976 | 60.675      | 65.70833333  |
| Alabama | 1968 | 61.0        | 65.70833333  |
| Alabama | 1940 | 61.175      | 65.70833333  |
| Alabama | 1983 | 61.19166667 | 65.70833333  |
| Alabama | 1958 | 61.21666667 | 65.70833333  |
| Alabama | 1979 | 61.35833333 | 65.70833333  |
| Alabama | 1969 | 61.36666667 | 65.70833333  |
| Alabama | 1901 | 61.39166667 | 65.70833333  |
| Alabama | 1960 | 61.54166667 | 65.70833333  |
| Alabama | 1895 | 61.64166667 | 65.70833333  |

Are the highest recorded temps for each state more recent or more historic?

>The highest temps are usually more recent

### 5. Let’s see how temperature has changed each year in each state.

Write a query to select the same columns but now you should write a window function that returns the change_in_temp from the previous year (no null values should be returned).

```SQL
SELECT state,
      year,
      tempf,
      tempf - LAG(tempf, 1, tempf) OVER(
          PARTITION BY state
          ORDER BY year
      )AS change_in_temp --shows the difference in tempf per year by state
FROM state_climate;
```

First 10 results:
| state   | year | tempf       | change_in_temp      |
|---------|------|-------------|---------------------|
| Alabama | 1895 | 61.64166667 | 0.0                 |
| Alabama | 1896 | 64.26666667 | 2.62500000000001    |
| Alabama | 1897 | 64.19166667 | -0.0750000000000028 |
| Alabama | 1898 | 62.98333333 | -1.20833334         |
| Alabama | 1899 | 63.1        | 0.116666670000001   |
| Alabama | 1900 | 63.40833333 | 0.308333329999996   |
| Alabama | 1901 | 61.39166667 | -2.01666666         |
| Alabama | 1902 | 63.58333333 | 2.19166666          |
| Alabama | 1903 | 61.975      | -1.60833333         |
| Alabama | 1904 | 62.76666667 | 0.791666669999998   |

####   * Which states and years saw the largest changes in temperature?

  I added the following line to the previous query to return the top changes.
  
 ``` SQL
...
ORDER BY change_in_temp;
```

First 10 results:
| state        | year | tempf       | change_in_temp    |
|--------------|------|-------------|-------------------|
| Minnesota    | 2013 | 39.325      | -5.875            |
| Wisconsin    | 2013 | 41.775      | -5.61666667       |
| Minnesota    | 1932 | 39.56666667 | -5.46666666       |
| Iowa         | 2013 | 46.65833333 | -5.41666667000001 |
| North Dakota | 1982 | 37.83333333 | -5.38333334       |
| North Dakota | 2013 | 38.79166667 | -5.34166666       |
| South Dakota | 2013 | 44.04166667 | -5.225            |
| Idaho        | 1935 | 41.79166667 | -5.125            |
| Iowa         | 1932 | 47.025      | -4.99166667       |
| Montana      | 1982 | 38.99166667 | -4.96666666       |

>  Most the biggest changes are in either the 2010s or the 1930s and  are in Minnesota, Wisconsin, Iowa, North and South Dakota, Idaho, and Montana

#### * Is there a particular part of the United States that saw the largest yearly changes in temperature?

> The biggest changes are mostly in the Midwest.


## Ranking Functions


### 6. Write a query to return a rank of the coldest temperatures on record (coldest_rank) along with year, state, and tempf or tempc.

```SQL
ELECT RANK()OVER (
  ORDER BY tempf
  ) as coldest_rank, --ranks by the coldest entries
  year,
  state,
  tempf
FROM state_climate;
```

First 10 Results:
| coldest_rank | year | state        | tempf       |
|--------------|------|--------------|-------------|
| 1            | 1950 | North Dakota | 34.9        |
| 2            | 1951 | North Dakota | 35.61666667 |
| 3            | 1917 | Minnesota    | 35.675      |
| 4            | 1916 | North Dakota | 35.73333333 |
| 5            | 1917 | North Dakota | 35.91666667 |
| 6            | 1899 | North Dakota | 36.25       |
| 7            | 1896 | North Dakota | 36.425      |
| 8            | 1950 | Minnesota    | 36.45833333 |
| 9            | 1904 | Maine        | 36.51666667 |
| 9            | 1996 | North Dakota | 36.51666667 |

#### Are the coldest ranked years recent or historic? The coldest years should be from any state or year.

> The coldest years are historic.

### 7. Modify your coldest_rank query to now instead return the warmest_rank for each state, meaning your query should return the warmest temp/year for each state.

```SQL
SELECT RANK()OVER (
     PARTITION BY state -- sorts by state
     ORDER BY tempf DESC -- ranks by warmest entry
  ) as warmest_rank,
  year,
  state,
  tempf
FROM state_climate; 
```

First 10 Results:
| warmest_rank | year | state   | tempf       |
|--------------|------|---------|-------------|
| 1            | 1921 | Alabama | 65.70833333 |
| 2            | 1927 | Alabama | 65.58333333 |
| 3            | 2019 | Alabama | 65.375      |
| 4            | 2016 | Alabama | 65.34166667 |
| 5            | 1911 | Alabama | 65.325      |
| 6            | 1922 | Alabama | 65.16666667 |
| 7            | 1998 | Alabama | 65.125      |
| 8            | 1933 | Alabama | 65.1        |
| 9            | 2017 | Alabama | 65.03333333 |
| 10           | 1925 | Alabama | 64.95833333 |

#### Again, are the warmest temperatures more recent or historic for each state?


  I added the following line to the previous query to get a better view of the warmest years
  
 ``` SQL
...
ORDER BY warmest_rank; 
```

First 10 Results:
| warmest_rank | year | state       | tempf       |
|--------------|------|-------------|-------------|
| 1            | 1921 | Alabama     | 65.70833333 |
| 1            | 2017 | Arizona     | 63.03333333 |
| 1            | 2012 | Arkansas    | 63.60833333 |
| 1            | 2014 | California  | 61.45       |
| 1            | 2012 | Colorado    | 48.31666667 |
| 1            | 2012 | Connecticut | 52.46666667 |
| 1            | 2012 | Delaware    | 58.475      |
| 1            | 2015 | Florida     | 73.35833333 |
| 1            | 2019 | Georgia     | 66.225      |
| 1            | 1934 | Idaho       | 46.91666667 |

> most of the warmest years are recent

###  8.Let’s now write a query that will return the average yearly temperatures in quartiles instead of in rankings for each state. 

Your query should return quartile, year, state and tempf or tempc. The top quartile should be the coldest years.

```SQL
SELECT NTILE(4) OVER(
    PARTITION BY state
    ORDER BY tempf
) AS quartile, --returns quartile per state by lowest tempf
  year,
  state,
  tempf
FROM state_climate;
```

First 10 Result:
| quartile | year | state   | tempf       |
|----------|------|---------|-------------|
| 1        | 1976 | Alabama | 60.675      |
| 1        | 1968 | Alabama | 61.0        |
| 1        | 1940 | Alabama | 61.175      |
| 1        | 1983 | Alabama | 61.19166667 |
| 1        | 1958 | Alabama | 61.21666667 |
| 1        | 1979 | Alabama | 61.35833333 |
| 1        | 1969 | Alabama | 61.36666667 |
| 1        | 1901 | Alabama | 61.39166667 |
| 1        | 1960 | Alabama | 61.54166667 |
| 1        | 1895 | Alabama | 61.64166667 |


#### Are the coldest years more recent or historic?

> The majority of first quartile years are historic

### 9. Lastly, we will write a query that will return the average yearly temperatures in quintiles (5).

Your query should return quintile, year, state and tempf or tempc. The top quintile should be the coldest years overall, not by state.

```SQL
SELECT NTILE(5) OVER (
  ORDER BY tempf
) AS quintile, -- returns quintile by lowest tempf
  year,
  state,
  tempf
FROM state_climate;
```

First Ten Results:
| quintile | year | state        | tempf       |
|----------|------|--------------|-------------|
| 1        | 1950 | North Dakota | 34.9        |
| 1        | 1951 | North Dakota | 35.61666667 |
| 1        | 1917 | Minnesota    | 35.675      |
| 1        | 1916 | North Dakota | 35.73333333 |
| 1        | 1917 | North Dakota | 35.91666667 |
| 1        | 1899 | North Dakota | 36.25       |
| 1        | 1896 | North Dakota | 36.425      |
| 1        | 1950 | Minnesota    | 36.45833333 |
| 1        | 1904 | Maine        | 36.51666667 |
| 1        | 1996 | North Dakota | 36.51666667 |

#### What is different about the coldest quintile now?
> Most of the results in the top quintile are in Northern states.
