require 'pg'

CONN = PG.connect(dbname: 'bank_processes', password: 'usertest', port: 5432)
