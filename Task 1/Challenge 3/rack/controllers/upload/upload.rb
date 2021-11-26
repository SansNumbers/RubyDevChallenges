require './controllers/services/base_controller'
require './controllers/services/pg_connect'

class Upload < BaseController

  def call(env)
    super
  end

  def index(_env, _request)
    render 'views/upload_csv.html.erb'
  end
end
