require 'pg'
require 'erb'
require './controllers/render'
require './controllers/pg_connect'

class States
  include Render

  def call(env)
    request = Rack::Request.new(env)
    index(request, env)
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

    render 'views/states.html.erb'
  end
end
