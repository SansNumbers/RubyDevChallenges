require 'pg'

conn = PG.connect(:dbname => 'bank_processes', :password => 'usertest', :port => 5432)

conn.exec(
  'DROP TABLE IF EXISTS offices, zones, rooms, fixtures, materials;'
)
