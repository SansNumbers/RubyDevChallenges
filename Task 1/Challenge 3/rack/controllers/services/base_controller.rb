class BaseController

  def call(env)
    request = Rack::Request.new(env)
    index(request, env)
  end

  def render(str)
    template = File.read(str)
    body = ERB.new(template)
    [200, { 'Content-Type' => 'text/html' }, [body.result(binding)]]
  end

end
