class Exceptions
  attr_reader :app
  def initialize(app)
    @app = app
  end

  def call(env)
  end
end
