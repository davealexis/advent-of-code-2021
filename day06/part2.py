import sqlite3

conn = sqlite3.connect(':memory:')
cursor = conn.cursor()
cursor.execute("CREATE TABLE IF NOT EXISTS fish (counter int, fish bigint);")
cursor.execute("insert into fish values (0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (5, 0), (6, 0), (7, 0), (8, 0), (9, 0)")

with open('input.txt', 'r') as f:
    data = f.readlines()[0].strip().split(',')


for i in data:
    conn.execute('update fish set fish = fish + 1 where counter = :1', (i))

for day in range(0, 256):
    print(f"Day {day}\r", end="")
    cursor.execute("update fish set fish = coalesce(fish, 0) + (select sum(fish) from fish where counter = 0) where counter = 9;")
    cursor.execute("update fish set fish = coalesce(fish, 0) + (select sum(fish) from fish where counter = 0) where counter = 7;")
    cursor.execute("update fish set fish = 0 where counter = 0;")
    cursor.execute("update fish set fish = (select fish from fish pd where pd.counter = fish.counter + 1);")
    conn.commit()

cursor.execute("select sum(fish) from fish;")
r = cursor.fetchone()
print(f"{r[0]:10,d}")