# DSCI 551 Final Project
PostgreSQL Indexing and Query Execution Analysis

## Project Overview
This project explores PostgreSQL internals using an Online Game Player Match History System. The main focus is on B-tree indexing and how SQL execution changes before and after indexing.

The application stores player information and match records, then supports operations such as viewing match history, ranking usernames by total score, ranking usernames by average score, and observing PostgreSQL execution plans with EXPLAIN ANALYZE.

## Files
- project_large.sql: creates the PostgreSQL tables, generates 20 usernames and 5000 synthetic match records, creates the B-tree index, and includes EXPLAIN ANALYZE statements for the final analysis
- project_small.sql: small dataset version used for the midterm checkpoint
- game_app_real.py: Python command-line application for interacting with the PostgreSQL database
- DSCI551_Final_Project_Sinan_Disi.pdf: final project report

## Requirements
- PostgreSQL
- pgAdmin 4 or another PostgreSQL client
- Python 3
- psycopg2 library

Install psycopg2 with:

```bash
pip install psycopg2
```

## Setup Instructions
1. Install PostgreSQL and pgAdmin 4.
2. Start the PostgreSQL server.
3. Create a new database named:

```text
game_match_history
```

4. Open pgAdmin 4 and connect to the `game_match_history` database.
5. Open the Query Tool.
6. Run:

```text
project_large.sql
```

The script creates the tables, inserts the synthetic dataset, runs example SQL statements, creates the index, and runs EXPLAIN ANALYZE statements.

Note: Make sure PostgreSQL server is running before executing the script.

## Credentials
This project does not include any secret keys, API keys, or hardcoded passwords.

The Python application asks for PostgreSQL credentials when it starts:
- database name
- PostgreSQL username
- PostgreSQL password

The password is entered manually at runtime and is not stored in the code.

Example:
- database name: game_match_history
- username: postgres
- password: your local PostgreSQL password

## Run Instructions
1. Open terminal or command prompt.
2. Run:

```bash
python game_app_real.py
```

3. Enter your PostgreSQL credentials when prompted.
4. Use the menu to:
   - show dataset counts
   - view match data
   - view top usernames by total score
   - view top usernames by average score
   - run EXPLAIN ANALYZE queries

## Dataset
The dataset is synthetic and generated automatically inside `project_large.sql`.

The script creates:
- 20 usernames
- 5000 match records
- scores between about 60 and 100
- dates distributed across about 90 days

No external dataset is required. Running `project_large.sql` generates and loads the dataset into PostgreSQL.

The dates follow a simple repeating pattern because the dataset is synthetic and designed mainly to demonstrate indexing and SQL execution behavior.

## Reproducing Results
To reproduce the main indexing result:

1. Run `project_large.sql` in pgAdmin 4.
2. The script first runs an EXPLAIN ANALYZE statement before creating the index:

```sql
EXPLAIN ANALYZE
SELECT *
FROM matches
WHERE player_id = 1
ORDER BY match_date;
```

3. Before indexing, PostgreSQL uses a sequential scan on the `matches` table.
4. The script then creates the B-tree index:

```sql
CREATE INDEX idx_matches_player_id
ON matches(player_id);
```

5. The same EXPLAIN ANALYZE statement is run again.
6. After indexing, PostgreSQL uses Bitmap Index Scan and Bitmap Heap Scan.
7. The script also includes an EXPLAIN ANALYZE statement for the join query between `players` and `matches`.

You can also reproduce these results through the Python menu:
- Option 5: EXPLAIN ANALYZE before index
- Option 6: EXPLAIN ANALYZE after index
- Option 7: EXPLAIN ANALYZE for join query

## Expected Output
After running `project_large.sql`, you should see:
- match history results for a selected username
- username rankings by total score
- username rankings by average score
- EXPLAIN ANALYZE output before indexing showing a sequential scan
- EXPLAIN ANALYZE output after indexing showing Bitmap Index Scan and Bitmap Heap Scan
- EXPLAIN ANALYZE output for the join query between `players` and `matches`

When running `game_app_real.py`, the command-line menu should allow the user to view dataset counts, match history, rankings, and execution plans.

## Key Focus
- B-tree indexing in PostgreSQL
- Sequential Scan vs Bitmap Index Scan
- Bitmap Heap Scan
- Cost-based query planner behavior
- Query execution analysis using EXPLAIN ANALYZE
