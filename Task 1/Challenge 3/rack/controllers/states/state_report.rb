require './controllers/services/render'
require './controllers/services/call'
require './controllers/services/pg_connect'

class StateId < Call
  include Render

  def call(env)
    super
  end

  private

  def index(_request, env)
    @result = CONN.exec(
      "SELECT * from offices WHERE state = '#{env['rack.route_params'][:state].upcase}' "
    )

    render 'views/state_report.html.erb'
  end
end
