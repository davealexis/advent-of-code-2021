import
    std/db_sqlite,
    strutils,
    std/strformat,
    std/sequtils,
    sugar

const inputFileName: string = "test-input.txt"

proc run() =
    let db = open("test.db", "", "", "")
    defer: db.close()

    # db.exec(sql"drop table fish;")
    # db.exec(sql"CREATE TABLE fish (counter int, fish bigint);")
    db.exec(sql"delete from fish;")
    db.exec(sql"insert into fish values (0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (5, 0), (6, 0), (7, 0), (8, 0), (9, 0)")

    var data = readFile(inputFileName).strip().split(",").map(f => parseInt(f))
    echo data

    for f in data:
        db.exec(sql"update fish set fish = fish + 1 where counter = ?", f)

    for day in 1..18:
        db.exec(sql"""
            update fish 
                set fish = 
                    case 
                        when counter in (7, 9) then coalesce(fish, 0) + (select sum(fish) from fish where counter = 0) 
                        when counter = 0 then 0
                    end
            where counter in (0, 7, 9);
        """)
        db.exec(sql"update fish set fish = (select fish from fish pd where pd.counter = fish.counter + 1);")

    for r in db.fastRows(sql"select sum(fish) from fish"):
        echo r
run()