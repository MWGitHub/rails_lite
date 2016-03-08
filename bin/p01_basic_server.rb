#!/usr/bin/env ruby

require 'rack'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  res['Content-Type'] = 'text/html'
  if req.path == '/other'
    res.write('Other stuff')
  else
    res.write('Hello world!')
  end
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
