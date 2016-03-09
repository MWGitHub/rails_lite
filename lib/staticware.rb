class Staticware
  attr_accessor :folders
  attr_reader :app

  def initialize(app)
    @app = app
    @folders = {
      'app/static/' => '/static/',
      'public/' => '/public/'
    }
  end

  def call(env)
    req = Rack::Request.new(env)
    res = Rack::Response.new

    folder = @folders.find do |dir, path|
      req.path[0...path.length] == path
    end

    if folder
      dir, path = folder
      location = "#{dir}#{req.path[path.length..-1]}"
      if File.exists?(location)
        file = File.read(location)
        res.write(file)
      else
        res.status = 404
        res['Content-Type'] = 'text/html'
        res.write('File not found')
      end
      res.finish
    else
      app.call(env)
    end
  end
end
