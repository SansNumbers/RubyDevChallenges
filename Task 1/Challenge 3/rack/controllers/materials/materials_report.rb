require './controllers/services/base_controller'
require './reports/materials'
require './controllers/services/pg_connect'

class Materials < BaseController
  def call(env)
    super
  end

  private

  def index(_request, _env)
    @new_hash = MaterialsReport.new.wake
    puts @new_hash

    render 'views/materials_report.html.erb'
  rescue IndexError
    [200, { 'Content-Type' => 'text/html' }, ["<h1>ERROR: Invalid parameters.</h1>"]]
  end
end
