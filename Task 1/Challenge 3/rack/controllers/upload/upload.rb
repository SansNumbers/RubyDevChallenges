require './controllers/services/render'
require './controllers/services/call'
require './controllers/services/pg_connect'

class Upload < Call
  include Render

  def call(env)
    super
  end

  def index(_env, _request)
    render 'views/upload_csv.html.erb'
  end
end
