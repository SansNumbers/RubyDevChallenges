require './controllers/services/pg_connect'

class StateReport
  def stateWake(env)
    @result = CONN.exec(
      "SELECT * from offices WHERE state = '#{env['rack.route_params'][:state].upcase}' "
    )
  end
end

class StatesReport
  def wake
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
  end
end
