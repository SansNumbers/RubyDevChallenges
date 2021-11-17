require 'pg'

CONN = PG.connect(dbname: 'bank_processes', password: 'usertest', port: 5432)

CONN.exec(
  'DROP TABLE IF EXISTS offices, zones, rooms, fixtures, materials;'
)
