require './controllers/services/base_controller'
require './controllers/services/pg_connect'
require './reports/states'

class StateId < BaseController
  def call(env)
    super
  end

  private

  def index(_request, env)
    @result = StateReport.new.stateGen(env)

    render 'views/state_report.html.erb'
  end
end
