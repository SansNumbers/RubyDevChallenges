require 'pg'
require 'erb'
require './controllers/render'
require './controllers/pg_connect'

class Materials
  include Render

  def call(env)
    request = Rack::Request.new(env)
    index(request, env)
  end

  private

  def index(_request, _env)
    @materials = Hash.new { |hash, key| hash[key] = [] }

    offices_name = CONN.exec("SELECT name, id FROM offices")

    @hash = {}
    result = {}
    offices_name.each do |data|
      result[data["name"]] = CONN.exec(
        "SELECT materials.type, materials.cost
         FROM (((( offices
         INNER JOIN zones ON offices.id = zones.office_id)
         INNER JOIN rooms ON zones.id = rooms.zone_id)
         INNER JOIN fixtures ON rooms.id = fixtures.room_id)
         INNER JOIN materials ON fixtures.id = materials.fixture_id)
         WHERE offices.id = #{data['id']};
         "
      )
      @hash[data["name"]] = {}
    end

    @cost = []

    result.each do |key, value|
      temp = 0
      value.each do |data|
        if @hash[key][data["type"]]
          @hash[key][data["type"]] += data["cost"].to_i
        else
          @hash[key][data["type"]] = data["cost"].to_i
        end
        temp += data["cost"].to_i
      end
      @cost << temp
    end

    @labels = Hash.new { |hash, key| hash[key] = [] }
    @data = Hash.new { |hash, key| hash[key] = [] }
    @hash.each do |key, value|
      value.each do |k, v|
        @labels[key] << k
        @data[key] << v
      end
    end

    render 'views/materials_report.html.erb'
  rescue IndexError
    [200, { 'Content-Type' => 'text/html' }, ["<h1>ERROR: Invalid parameters.</h1>"]]
  end
end
