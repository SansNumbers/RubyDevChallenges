require './controllers/app'
require './controllers/states/state_report'
require './controllers/states/states_report'
require './controllers/fixtures/fixture_report'
require './controllers/fixtures/fixtures_report'

require 'rack/router'

use Rack::Static,
    urls: ['/css'],
    root: 'public'

app = Rack::Router.new do
  get '/' => App.new
  post '/' => App.new
  get '/reports/states' => States.new
  get '/reports/states/' => States.new
  get '/reports/states/:state' => StateId.new
  get '/reports/offices/fixture_types' => Fixtures.new
  get '/reports/offices/fixture_types/' => Fixtures.new
  get '/reports/offices/:id/fixture_types' => FixtureId.new
end

run app
