class Exceptionware
  attr_reader :app
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      app.call(env)
    rescue StandardError => e
      @error = e

      location = e.backtrace[1].split(' ')[0].split(':')
      file = location[0]
      error_line = location[1].to_i
      buffer = 10
      @source = ''
      File.foreach(file).with_index do |line, line_num|
        if (line_num - error_line).abs <= 10
          @source += "#{line_num}  #{line}"
        end
      end

      @backtrace = e.backtrace.join("\n")

      template = File.read('app/views/layouts/exception.html.erb')
      content = ERB.new(template).result(binding)

      res = Rack::Response.new
      res.write(content)
      res.finish
    end
  end
end
