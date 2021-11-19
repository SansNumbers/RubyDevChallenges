require 'pg'
require 'erb'
require './controllers/render'
require './controllers/pg_connect'

class FixtureId
  include Render

  def call(env)
    request = Rack::Request.new(env)
    index(request, env)
  end

  private

  def index(_request, env)
    @hash = {}
    @office_name = CONN.exec("SELECT name FROM offices WHERE id = #{env['rack.route_params'][:id]}")[0]

    puts @office_name

    @hash[@office_name["name"]] = CONN.exec(
      "SELECT fixtures.type
        FROM ((( offices
        INNER JOIN zones ON offices.id = zones.office_id)
        INNER JOIN rooms ON zones.id = rooms.zone_id)
        INNER JOIN fixtures ON rooms.id = fixtures.room_id)
        WHERE offices.id = #{env['rack.route_params'][:id]};
        "
    )

    @hash.each do |key, value|
      @hash[key] = value.each_with_object(Hash.new(0)) do |i, memo|
        memo[i] += 1
      end
    end

    @total = 0
    @hash.each do |key, value|
      puts "#{key} => "
      value.each do |_k, v|
        @total += v
      end
    end

    render 'views/fixture_report.html.erb'
  rescue IndexError
    [200, { 'Content-Type' => 'text/html' }, ["<h1>ERROR: Invalid parameters.</h1>"]]
  end
end
