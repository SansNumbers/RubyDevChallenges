require 'pg'
require 'erb'
require './controllers/render'
require './controllers/pg_connect'

class States
  include Render
  def call(env)
    request = Rack::Request.new(env)
    index
  end

  def index
    offices = CONN.exec(
      'SELECT state FROM offices'
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

    render 'views/states.html.erb'
  end
end

class StateId
  include Render

  def call(env)
    request = Rack::Request.new(env)
    index(request, env)
  end

  def index(_request, env)
    if env['REQUEST_URI'] == '/reports/states/ca' || env['REQUEST_URI'] == '/reports/states/ny'
      @result = CONN.exec(
        "SELECT * from offices WHERE state = '#{env['rack.route_params'][:state].upcase}' "
      )
    else
      Rack::Response.new(
        "<h1>Invalid Url: #{env['REQUEST_URI']}</h1> ",
        200,
        { 'Content-Type' => 'text/html' }
      )
    end

    render 'views/state_report.html.erb'
  end
end
