-- =====================================================
-- DSCI 551 FINAL PROJECT
-- PostgreSQL Online Game Player Match History System
-- Large Dataset Version for Final Demo and Analysis
-- =====================================================

-- =====================================================
-- 0) CLEANUP
-- Remove old tables so the script can be rerun safely
-- =====================================================

DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS players;

-- =====================================================
-- 1) CREATE TABLES
-- =====================================================

CREATE TABLE players (
    player_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE matches (
    match_id SERIAL PRIMARY KEY,
    player_id INT NOT NULL,
    score INT NOT NULL,
    match_date DATE NOT NULL,
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- =====================================================
-- 2) INSERT PLAYER DATA
-- 20 players are inserted for the larger final dataset
-- =====================================================

INSERT INTO players (username) VALUES
('Jaina'),
('Illidan'),
('Sylvanas'),
('Voljin'),
('Anduin'),
('Guldan'),
('Vashj'),
('Kaelthas'),
('Medivh'),
('Maiev'),
('Baine'),
('Senjin'),
('Akama'),
('Talanji'),
('Zekhan'),
('Daein'),
('Elune'),
('Vaela'),
('Nozdah'),
('Kelia');

-- =====================================================
-- 3) INSERT LARGE MATCH DATASET
-- 5000 synthetic match records are generated automatically
-- Scores are roughly between 60 and 100
-- Dates are spread across about 90 days
-- =====================================================

INSERT INTO matches (player_id, score, match_date)
SELECT
    ((g - 1) % 20) + 1 AS player_id,
    60 + (random() * 40)::INT AS score,
    DATE '2026-01-01' + ((g - 1) % 90)
FROM generate_series(1, 5000) AS g;

-- =====================================================
-- 4) CHECK DATA SIZE
-- Confirm the number of players and matches
-- =====================================================

SELECT COUNT(*) FROM players;
SELECT COUNT(*) FROM matches;

-- =====================================================
-- 5) QUERY 1: SHOW ONE PLAYER'S MATCH HISTORY
-- =====================================================

SELECT p.username, m.match_id, m.score, m.match_date
FROM players p
JOIN matches m ON p.player_id = m.player_id
WHERE p.username = 'Jaina'
ORDER BY m.match_date;

-- =====================================================
-- 6) QUERY 2: SHOW TOP PLAYERS BY TOTAL SCORE
-- =====================================================

SELECT p.username, SUM(m.score) AS total_score
FROM players p
JOIN matches m ON p.player_id = m.player_id
GROUP BY p.username
ORDER BY total_score DESC;

-- =====================================================
-- 7) QUERY 3: SHOW TOP PLAYERS BY AVERAGE SCORE
-- Rounded to 2 decimal places for cleaner output
-- =====================================================

SELECT p.username, ROUND(AVG(m.score), 2) AS avg_score
FROM players p
JOIN matches m ON p.player_id = m.player_id
GROUP BY p.username
ORDER BY avg_score DESC;

-- =====================================================
-- 8) EXPLAIN ANALYZE BEFORE INDEX
-- Show query execution before index creation
-- =====================================================
DROP INDEX IF EXISTS idx_matches_player_id;

EXPLAIN ANALYZE
SELECT *
FROM matches
WHERE player_id = 1
ORDER BY match_date;

-- =====================================================
-- 9) CREATE INDEX
-- PostgreSQL uses B-tree by default for CREATE INDEX
-- =====================================================

CREATE INDEX idx_matches_player_id
ON matches(player_id);

-- =====================================================
-- 10) EXPLAIN ANALYZE AFTER INDEX
-- Show how the execution plan changes after indexing
-- =====================================================

EXPLAIN ANALYZE
SELECT *
FROM matches
WHERE player_id = 1
ORDER BY match_date;

-- =====================================================
-- 11) EXPLAIN ANALYZE FOR JOIN QUERY
-- Useful for showing how PostgreSQL handles
-- filtering, join processing, and sorting together
-- =====================================================

EXPLAIN ANALYZE
SELECT p.username, m.match_id, m.score, m.match_date
FROM players p
JOIN matches m ON p.player_id = m.player_id
WHERE p.username = 'Jaina'
ORDER BY m.match_date;

-- =====================================================
-- 12) EXTRA CHECK
-- Confirm that the index exists on the matches table
-- =====================================================

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'matches';


-- =====================================================
--  EXTRA (To DROP the INDEX When Needed)
-- =====================================================
--DROP INDEX IF EXISTS idx_matches_player_id;

--EXPLAIN ANALYZE
--SELECT *
--FROM matches
--WHERE player_id = 1
--ORDER BY match_date;