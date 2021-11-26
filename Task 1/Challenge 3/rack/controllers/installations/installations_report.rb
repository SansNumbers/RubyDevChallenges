require './controllers/services/base_controller'
require './controllers/services/pg_connect'

class Installations < BaseController
  def call(env)
    super
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
