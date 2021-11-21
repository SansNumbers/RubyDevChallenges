require 'pg'
require 'erb'
require './controllers/render'
require './controllers/pg_connect'

class InstallationId
  include Render

  def call(env)
    request = Rack::Request.new(env)
    index(request, env)
  end

  private

  def index(_request, env)
    @office = CONN.exec("SELECT name, state, address, phone, type FROM offices WHERE id =
        #{env['rack.route_params'][:id]}")[0]

    zones = CONN.exec(
      "SELECT type, id FROM zones WHERE office_id = #{env['rack.route_params'][:id]}"
    )

    rooms = {}
    @response = {}

    zones.each do |data|
      rooms[data["type"]] = CONN.exec(
        "SELECT name, id FROM rooms WHERE zone_id = #{data['id']}"
      )
    end

    rooms.each do |key, value|
      temp = {}
      value.each do |data|
        fixtures = CONN.exec(
          "SELECT mm.type marketing_material_type, mm.name marketing_material_name,
             fix.name fixture_name, fix.type fixture_type
             FROM (( rooms
             INNER JOIN fixtures fix ON rooms.id = fix.room_id)
             INNER JOIN materials mm ON fix.id = mm.fixture_id)
             WHERE rooms.id = #{data['id']}"
        )
        temp.store(data["name"], fixtures)
        @response[key] = temp
      end
    end

    @sum = CONN.exec(
      "SELECT SUM(rooms.area) area, SUM(rooms.max_people) people
         FROM (( offices
           INNER JOIN zones ON offices.id = zones.office_id)
           INNER JOIN rooms ON zones.id = rooms.zone_id)
           WHERE offices.id = #{env['rack.route_params'][:id]};"
    )

    render 'views/installation_report.html.erb'
  rescue IndexError
    [200, { 'Content-Type' => 'text/html' }, ["<h1>ERROR: Invalid parameters.</h1>"]]
  end
end
