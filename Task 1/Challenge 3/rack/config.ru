require './controllers/app'
require 'rack/router'

app = Rack::Router.new do
  get '/' => App.new
  post '/' => App.new
end

run app
