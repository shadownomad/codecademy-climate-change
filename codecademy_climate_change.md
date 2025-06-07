# CodeCademy Climate Change
## Understanding the Data
1. Let’s see what our table contains by running the following command:

```SQL
SELECT * 
FROM state_climate;

```

First 10 results:
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
2. Let’s start by looking at how the average temperature changes over time in each state.

Write a query that returns the state, year, tempf or tempc, and running_avg_temp (in either Celsius or Fahrenheit) for each state.

(The running_avg_temp should use a window function.)

