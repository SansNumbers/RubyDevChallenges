require 'pg'

CONN = PG.connect(dbname: 'bank_processes', password: 'usertest', port: 5432)

CONN.exec(
  'CREATE TABLE IF NOT EXISTS "offices" (
        id SERIAL PRIMARY KEY,
        name VARCHAR NOT NULL,
        address VARCHAR NOT NULL,
        city VARCHAR NOT NULL,
        state VARCHAR NOT NULL,
        phone BIGINT,
        lob VARCHAR NOT NULL,
        type VARCHAR NOT NULL,
        UNIQUE(name, address, city, state, phone)
    );'
)

CONN.exec(
  'CREATE TABLE IF NOT EXISTS "zones" (
        id SERIAL PRIMARY KEY,
        type VARCHAR NOT NULL,
        office_id INT NOT NULL,
        UNIQUE(type, office_id)
    );
    ALTER TABLE "zones" ADD FOREIGN KEY ("office_id") REFERENCES "offices" ("id");'
)

CONN.exec(
  'CREATE TABLE IF NOT EXISTS "rooms" (
        id SERIAL PRIMARY KEY,
        name VARCHAR NOT NULL,
        max_people INT NOT NULL,
        area INT NOT NULL,
        zone_id INT NOT NULL,
        UNIQUE(name, zone_id)
    );
    ALTER TABLE "rooms" ADD FOREIGN KEY ("zone_id") REFERENCES "zones" ("id");'
)

CONN.exec(
  'CREATE TABLE IF NOT EXISTS "fixtures" (
        id SERIAL PRIMARY KEY,
        name VARCHAR NOT NULL,
        type VARCHAR NOT NULL,
        room_id INT NOT NULL
    );
    ALTER TABLE "fixtures" ADD FOREIGN KEY ("room_id") REFERENCES "rooms" ("id");'
)

CONN.exec(
  'CREATE TABLE IF NOT EXISTS "materials" (
        id SERIAL PRIMARY KEY,
        name VARCHAR NOT NULL,
        type VARCHAR NOT NULL,
        cost FLOAT NOT NULL,
        fixture_id INT NOT NULL,
        UNIQUE(name, fixture_id)
    );
    ALTER TABLE "materials" ADD FOREIGN KEY ("fixture_id") REFERENCES "fixtures" ("id");'
)
