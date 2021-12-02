require './controllers/services/pg_connect'

class StateReport
  def stateGen(env)
    @result = CONN.exec(
      "SELECT * from offices WHERE state = '#{env['rack.route_params'][:state].upcase}' "
    )
  end
end

# class StatesReport
#   def wake

#   end
# end
