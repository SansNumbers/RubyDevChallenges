require './controllers/services/base_controller'
require './controllers/services/pg_connect'
# require './reports/states'

class States < BaseController
  def call(env)
    super
  end

  private

  def index(_request, _env)
    offices = CONN.exec(
      'SELECT * FROM offices ORDER BY state'
    )

    array = []
    offices.each { |data| array.push(data['state']) }
    array.uniq!

    @offices = []
    array.each do |data|
      @offices.push(CONN.exec(
                      "SELECT * FROM offices WHERE state = '#{data}'"
                    ))
    end

    render 'views/states_report.html.erb'
  end
end
