require 'rack'

handler = Rack::Handler::WEBrick

class RackApp
  def call(env)
    req = Rack::Request.new(env)
    if req.ip == "5.5.5.5"
      [403, {}, ""]
    else
      [200, {"Content-Type" => "text/plain"}, ["Hello from Rack"]]
    end
  end
end

handler.run RackApp.new
