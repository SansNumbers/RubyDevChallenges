require './controllers/app'
require './controllers/state_report'

require 'rack/router'

use Rack::Static,
    urls: ['/css'],
    root: 'public'

app = Rack::Router.new do
  get '/' => App.new
  post '/' => App.new
  get '/reports/states' => States.new
  get '/reports/states/:state' => StateId.new
end

run app
