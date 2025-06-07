# CodeCademy Climate Change
## Understanding the Data
> 1. Let’s see what our table contains by running the following command:

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
>2. Let’s start by looking at how the average temperature changes over time in each state.
>
>Write a query that returns the state, year, tempf or tempc, and running_avg_temp (in either Celsius or Fahrenheit) for each state.
>
>(The running_avg_temp should use a window function.)

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

>3.
>Now let’s explore the lowest temperatures for each state.
>
>Write a query that returns state, year, tempf or tempc, and the lowest temperature (lowest_temp) for each state.

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

>Are the lowest recorded temps for each state more recent or more historic?

The lowest temps are consistently more historic


>Like before, write a query that returns state, year, tempf or tempc, except now we will also return the highest temperature (highest_temp) for each state.

```SQL
ELECT state,
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

>Are the highest recorded temps for each state more recent or more historic?
 The highest temps are usually more recent

