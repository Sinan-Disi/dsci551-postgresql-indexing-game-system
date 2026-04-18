# DSCI 551 Final Project
PostgreSQL Indexing and Query Execution Analysis

## Project Overview
This project explores PostgreSQL internals using an Online Game Player Match History System. The main focus is on B-tree indexing and how SQL execution changes before and after indexing.

## Files
- project_large.sql: creates tables and inserts large dataset (5000 rows)
- project_small.sql: small dataset version
- game_app_real.py: Python command-line application
- DSCI551_Final_Project_Sinan_Disi.pdf: final project report

## Requirements
- PostgreSQL
- Python 3
- psycopg2 library

## Setup Instructions
1. Install PostgreSQL and open pgAdmin 4
2. Create a new database:
   - game_match_history (for large dataset)
3. Open Query Tool and run:
   - project_large.sql

Note: Make sure PostgreSQL server is running before executing the script.

## Run Instructions
1. Open terminal or command prompt
2. Run:
   python game_app_real.py
3. Enter your PostgreSQL credentials when prompted:
   - database name: game_match_history
   - username: postgres
   - password: your PostgreSQL password
4. Use the menu to:
   - view match data
   - view top usernames
   - run EXPLAIN ANALYZE queries

## Dataset
The dataset is synthetic and generated using SQL:
- 20 usernames
- 5000 match records
- scores between ~60–100
- dates distributed across ~90 days
- Dates follow a simple repeating pattern due to how the synthetic data is generated.

## Key Focus
- Sequential Scan vs Bitmap Index Scan
- Bitmap Heap Scan
- Query planner behavior using EXPLAIN ANALYZE
