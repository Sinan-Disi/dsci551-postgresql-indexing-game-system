import psycopg2
import getpass


# Connect to PostgreSQL using user input
def connect_db():
    db_name = input("Enter database name: ").strip()
    db_user = input("Enter PostgreSQL username: ").strip()
    db_password = getpass.getpass("Enter PostgreSQL password: ")

    return psycopg2.connect(
        host="localhost",
        database=db_name,
        user=db_user,
        password=db_password
    )


# Show match history for one username
def show_match_history(conn):
    username = input("Enter player username: ").strip()

    query = """
    SELECT p.username, m.match_id, m.score, m.match_date
    FROM players p
    JOIN matches m ON p.player_id = m.player_id
    WHERE p.username = %s
    ORDER BY m.match_date;
    """

    with conn.cursor() as cur:
        cur.execute(query, (username,))
        rows = cur.fetchall()

    if not rows:
        print("\nNo match history found.\n")
        return

    print(f"\nMatch history for {username}:")
    print("-" * 50)
    for row in rows[:20]:
        print(row)
    print("-" * 50)
    print(f"Showing first 20 rows out of {len(rows)} total rows.\n")


# Show top usernames by total score
def show_top_total_scores(conn):
    query = """
    SELECT p.username, SUM(m.score) AS total_score
    FROM players p
    JOIN matches m ON p.player_id = m.player_id
    GROUP BY p.username
    ORDER BY total_score DESC;
    """

    with conn.cursor() as cur:
        cur.execute(query)
        rows = cur.fetchall()

    print("\nTop players by total score:")
    print("-" * 50)
    for row in rows:
        print(row)
    print("-" * 50)
    print()


# Show top usernames by average score
def show_top_avg_scores(conn):
    query = """
    SELECT p.username, ROUND(AVG(m.score)::numeric, 2) AS avg_score
    FROM players p
    JOIN matches m ON p.player_id = m.player_id
    GROUP BY p.username
    ORDER BY avg_score DESC;
    """

    with conn.cursor() as cur:
        cur.execute(query)
        rows = cur.fetchall()

    print("\nTop players by average score:")
    print("-" * 50)
    for row in rows:
        print((row[0], float(row[1])))
    print("-" * 50)
    print()


# Show execution plan before creating the index
def explain_before_index(conn):
    drop_index = """
    DROP INDEX IF EXISTS idx_matches_player_id;
    """

    explain_query = """
    EXPLAIN ANALYZE
    SELECT *
    FROM matches
    WHERE player_id = 1
    ORDER BY match_date;
    """

    with conn.cursor() as cur:
        cur.execute(drop_index)
        conn.commit()

        cur.execute(explain_query)
        rows = cur.fetchall()

    print("\nEXPLAIN ANALYZE before index:")
    print("-" * 70)
    for row in rows:
        print(row[0])
    print("-" * 70)
    print()


# Show execution plan after creating the index
def explain_after_index(conn):
    create_index = """
    CREATE INDEX IF NOT EXISTS idx_matches_player_id
    ON matches(player_id);
    """

    explain_query = """
    EXPLAIN ANALYZE
    SELECT *
    FROM matches
    WHERE player_id = 1
    ORDER BY match_date;
    """

    with conn.cursor() as cur:
        cur.execute(create_index)
        conn.commit()

        cur.execute(explain_query)
        rows = cur.fetchall()

    print("\nEXPLAIN ANALYZE after index:")
    print("-" * 70)
    for row in rows:
        print(row[0])
    print("-" * 70)
    print()


# Show execution plan for the join query
def explain_join_query(conn):
    query = """
    EXPLAIN ANALYZE
    SELECT p.username, m.match_id, m.score, m.match_date
    FROM players p
    JOIN matches m ON p.player_id = m.player_id
    WHERE p.username = 'Jaina'
    ORDER BY m.match_date;
    """

    with conn.cursor() as cur:
        cur.execute(query)
        rows = cur.fetchall()

    print("\nEXPLAIN ANALYZE for join query:")
    print("-" * 70)
    for row in rows:
        print(row[0])
    print("-" * 70)
    print()


# Show total number of players and matches
def show_counts(conn):
    with conn.cursor() as cur:
        cur.execute("SELECT COUNT(*) FROM players;")
        player_count = cur.fetchone()[0]

        cur.execute("SELECT COUNT(*) FROM matches;")
        match_count = cur.fetchone()[0]

    print("\nDataset size:")
    print("-" * 50)
    print(f"Players: {player_count}")
    print(f"Matches: {match_count}")
    print("-" * 50)
    print()


# Main menu for the application
def main():
    conn = None
    try:
        conn = connect_db()
        print("\nConnected to PostgreSQL.\n")

        while True:
            print("=== Online Game Player Match History System ===")
            print("1. Show dataset counts")
            print("2. Show one player's match history")
            print("3. Show top players by total score")
            print("4. Show top players by average score")
            print("5. EXPLAIN ANALYZE before index")
            print("6. EXPLAIN ANALYZE after index")
            print("7. EXPLAIN ANALYZE for join query")
            print("8. Exit")

            choice = input("Choose an option: ").strip()

            if choice == "1":
                show_counts(conn)
            elif choice == "2":
                show_match_history(conn)
            elif choice == "3":
                show_top_total_scores(conn)
            elif choice == "4":
                show_top_avg_scores(conn)
            elif choice == "5":
                explain_before_index(conn)
            elif choice == "6":
                explain_after_index(conn)
            elif choice == "7":
                explain_join_query(conn)
            elif choice == "8":
                print("\nExiting application.")
                break
            else:
                print("\nInvalid choice. Try again.\n")

    except Exception as e:
        print("\nError:", e)

    finally:
        if conn is not None:
            conn.close()
            print("Database connection closed.")


if __name__ == "__main__":
    main()