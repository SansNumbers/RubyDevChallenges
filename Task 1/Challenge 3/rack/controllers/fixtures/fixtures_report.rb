require './controllers/services/base_controller'
require './controllers/services/pg_connect'

class Fixtures < BaseController

  def call(env)
    super
  end

  private

  def index(_request, _env)
    @fixtures = CONN.exec(
      "SELECT * FROM fixtures"
    )

    @office = Hash.new { |hash, key| hash[key] = [] }

    @fixtures.each do |data|
      @office[data['type']] << CONN.exec(
        "SELECT * FROM offices WHERE id =
           (SELECT office_id FROM zones WHERE id =
           (SELECT zone_id FROM rooms WHERE id = '#{data['room_id']}'))"
      )[0]
    end

    @total_count = []

    @office.each do |key, _value|
      @total_count.push(CONN.exec(
                          "SELECT COUNT(*) FROM fixtures WHERE type = '#{key}'"
                        ))
    end

    @office.each do |key, value|
      @office[key] = value.each_with_object(Hash.new(0)) do |i, memo|
        memo[i] += 1
      end
    end

    render 'views/fixtures_report.html.erb'
  rescue IndexError
    [200, { 'Content-Type' => 'text/html' }, ["<h1>ERROR: Invalid parameters.</h1>"]]
  end
end
