class Routes < Router
  def initialize
    super

    draw do
      get Router.patternize('/cats'), CatsController, :index
      get Router.patternize('/cats/:cat_id/statuses'), StatusesController, :index
      get Router.patternize('/cats/new'), CatsController, :new
      get Router.patternize('/cats/other'), CatsController, :other
    end
  end
end
