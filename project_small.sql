-- =====================================================
-- DSCI 551 FINAL PROJECT
-- PostgreSQL Online Game Player Match History System
-- Small Dataset Version
-- =====================================================

-- Cleanup to rerun everything from scratch
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
-- 2) INSERT SAMPLE DATA
-- =====================================================

INSERT INTO players (username) VALUES
('Arthas'),
('Thrall'),
('Jaina'),
('Varian'),
('Illidan');

INSERT INTO matches (player_id, score, match_date) VALUES
(1, 82, '2026-02-01'),
(1, 95, '2026-02-03'),
(1, 88, '2026-02-06'),
(2, 76, '2026-02-01'),
(2, 91, '2026-02-04'),
(3, 89, '2026-02-02'),
(3, 93, '2026-02-05'),
(4, 71, '2026-02-03'),
(4, 81, '2026-02-07'),
(5, 97, '2026-02-02'),
(5, 90, '2026-02-08');

-- =====================================================
-- 3) UPDATE PLAYER NAMES
-- =====================================================

UPDATE players
SET username = CASE player_id
    WHEN 1 THEN 'Alex'
    WHEN 2 THEN 'Luke'
    WHEN 3 THEN 'Mia'
    WHEN 4 THEN 'Emma'
    WHEN 5 THEN 'Jake'
END
WHERE player_id IN (1, 2, 3, 4, 5);

-- =====================================================
-- 4) CHECK DATA
-- =====================================================

SELECT * FROM players;
SELECT * FROM matches;

-- =====================================================
-- 5) QUERY 1: SHOW ONE PLAYER'S MATCH HISTORY
-- =====================================================

SELECT p.username, m.match_id, m.score, m.match_date
FROM players p
JOIN matches m ON p.player_id = m.player_id
WHERE p.username = 'Alex'
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
-- =====================================================

SELECT p.username, AVG(m.score) AS avg_score
FROM players p
JOIN matches m ON p.player_id = m.player_id
GROUP BY p.username
ORDER BY avg_score DESC;

-- =====================================================
-- 8) EXPLAIN ANALYZE BEFORE INDEX
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
-- =====================================================

EXPLAIN ANALYZE
SELECT *
FROM matches
WHERE player_id = 1
ORDER BY match_date;

-- =====================================================
-- 11) RUN PLAYER MATCH HISTORY QUERY AGAIN AFTER INDEX
-- =====================================================

SELECT p.username, m.match_id, m.score, m.match_date
FROM players p
JOIN matches m ON p.player_id = m.player_id
WHERE p.username = 'Alex'
ORDER BY m.match_date;

-- =====================================================
-- 12) EXPLAIN ANALYZE FOR JOIN QUERY
-- Useful for report discussion on query execution
-- =====================================================

EXPLAIN ANALYZE
SELECT p.username, m.match_id, m.score, m.match_date
FROM players p
JOIN matches m ON p.player_id = m.player_id
WHERE p.username = 'Alex'
ORDER BY m.match_date;

-- =====================================================
-- 13) SHOW ALL PLAYERS AND ALL MATCHES
-- =====================================================

SELECT p.username, m.score, m.match_date
FROM players p
JOIN matches m ON p.player_id = m.player_id
ORDER BY p.username, m.match_date;

-- =====================================================
-- 14) Extra Check
-- =====================================================
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'matches';
