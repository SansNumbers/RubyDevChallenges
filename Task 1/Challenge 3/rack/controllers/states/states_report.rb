require './controllers/services/base_controller'
require './controllers/services/pg_connect'
require './reports/states'

class States < BaseController
  def call(env)
    super
  end

  private

  def index(_request, _env)
    @states = StatesReport.new.wake
    puts @states

    render 'views/states_report.html.erb'
  end
end
