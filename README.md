# python-data-science

## Requirements

- Python 2.7
- PostgreSQL 9.6.8

## Alphavantage data analysis
- [Main analysis notebook](Alphavantage%20data%20analysis.ipynb)
- [Open/Close prices plot](BTC_open_close.png)
- [Downloaded data](alphavantage.csv)

## TPU performance queries
- [Original, tiny sample data](tpu.csv)
- [Sample data generator](Sample%20data%20generator.ipynb)
- [Sample generated data for 100 users to test queries](sample_data.csv)
- ["Setup" query to generate schema and populate with sample data](setup.sql)
- [Main query file with view to answer posed questions](queries.sql)

With a clean installation of postgres and a ~/.pgpass file configured for a user with administrative privileges, one should be able to execute all of the queries via:

```
psql < setup.sql
psql < queries.sql
```

The answers to the specific questions can be found by "SELECT * FROM"-querying the views `count_unique_device_ids`, `tpu_avg_purchase_amount` and `tpu_average_time_delta`.

## Encuesta Nacional de Industrias data analysis

- [Main cleaning/analysis notebook](Encuesta%20Industrial%20de%20Chile%20data%20analysis.ipynb)

I did not have time to finish these exercise, but I did complete the cleaning tasks.

## What is missing?

This is an exploratory exercise. To make this code more maintainable, I should at least:
- Add a requirements.txt/Pipfile or similar file stating dependencies (pandas, numpy, matplotlib, requests, and some base libraries),
- Export the .ipynb notebooks to pure .py Python files, and get rid of most comments,
- Add complete documentation for most functions and
- Declare unit tests on key methods, like the data download script from Alphadvantage.
