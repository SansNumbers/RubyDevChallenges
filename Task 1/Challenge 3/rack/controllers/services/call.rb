class Call
  def call(env)
    request = Rack::Request.new(env)
    index(request, env)
  end
end
