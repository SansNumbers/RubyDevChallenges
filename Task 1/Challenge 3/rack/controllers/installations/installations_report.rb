require 'pg'
require 'erb'
require './controllers/render'
require './controllers/pg_connect'

class Installations
  include Render

  def call(env)
    request = Rack::Request.new(env)
    index(request, env)
  end

  private

  def index(request, _env)
    @offices = if request.post? && !request.POST["text"].empty?
                 CONN.exec(
                   "SELECT * FROM offices WHERE ts @@ to_tsquery('english', '#{request.POST['search']}');"
                 )
               else
                 CONN.exec(
                   "SELECT id, name FROM offices"
                 )
               end

    render 'views/installations_report.html.erb'
  end
end
