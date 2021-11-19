require 'pg'
require 'erb'
require './controllers/render'
require './controllers/pg_connect'

class StateId
  include Render

  def call(env)
    request = Rack::Request.new(env)
    index(request, env)
  end

  private

  def index(_request, env)
    @result = CONN.exec(
      "SELECT * from offices WHERE state = '#{env['rack.route_params'][:state].upcase}' "
    )

    render 'views/state_report.html.erb'
  end
end
