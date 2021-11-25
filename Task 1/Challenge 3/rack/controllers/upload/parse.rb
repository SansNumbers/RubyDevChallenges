require 'csv'
require 'pg'
require 'erb'

require './controllers/services/render'
require './controllers/services/pg_connect'
require './controllers/services/call'

class Parse
  include Render

  def call(env)
    request = Rack::Request.new(env)
    index(request)
  end

  private

  def parse(path)
    table = CSV.parse(File.read(path), headers: true)
  end

  def index(request)
    if request.post?
      table = parse(request.params['file'][:tempfile])

      table.by_row.each do |data|
        CONN.exec_params("INSERT INTO offices (id, name, address, city, state, phone, lob, type)
              VALUES (DEFAULT,
                $1,
                '#{data['Office address']}',
                '#{data['Office city']}',
                '#{data['Office State']}',
                #{data['Office phone'].to_i},
                '#{data['Office lob']}',
                '#{data['Office type']}')", [data["Office"]])
      rescue PG::UniqueViolation
        next
      end

      table.by_row.each do |data|
        CONN.exec_params(
          "INSERT INTO zones (id, type, office_id)
             VALUES (DEFAULT,
               $1,
               (SELECT id from offices WHERE name = $2));",
          [data['Zone'], data["Office"]]
        )
      rescue StandardError
        next PG::UniqueViolation
      end

      table.by_row.each do |data|
        CONN.exec_params(
          "INSERT INTO rooms (id, name, area, max_people, zone_id)
             VALUES (
               DEFAULT,
               '#{data['Room']}',
               '#{data['Room area']}',
               '#{data['Room max people']}',
               (SELECT id FROM zones
                WHERE (zones.type = '#{data['Zone']}'
                  AND zones.office_id = (SELECT id from offices WHERE name = $1))));",
          [data["Office"]]
        )
      rescue StandardError
        next PG::UniqueViolation
      end

      table.by_row.each do |data|
        CONN.exec_params(
          "INSERT INTO fixtures (id, name, type, room_id)
             VALUES (
               DEFAULT,
               '#{data['Fixture']}',
               '#{data['Fixture Type']}',
               (SELECT id FROM rooms
                WHERE ( rooms.name = '#{data['Room']}'
                AND rooms.zone_id = (SELECT id from zones
                  WHERE (type = '#{data['Zone']}'
                  AND office_id = (SELECT id from offices WHERE name = $1))))));",
          [data["Office"]]
        )
      rescue PG::InvalidTextRepresentation
        next
      end

      table.by_row.each do |data|
        CONN.exec_params(
          "INSERT INTO materials (id, name, type, cost, fixture_id)
             VALUES (
               DEFAULT,
               '#{data['Marketing material']}',
               '#{data['Marketing material type']}',
                #{data['Marketing material cost'].to_i},
               (SELECT id FROM fixtures
                 WHERE name = '#{data['Fixture']}'
                 AND room_id = (SELECT id FROM rooms
                  WHERE ( rooms.name = '#{data['Room']}'
                    AND rooms.zone_id = (SELECT id from zones
                      WHERE (type = '#{data['Zone']}'
                      AND office_id = (SELECT id from offices WHERE name = $1)))))));",
          [data["Office"]]
        )
      rescue PG::CardinalityViolation
        next
      end
    end

    render 'views/upload_csv.html.erb'
  end
end
