class Routes < Router
  def initialize
    super

    draw do
      get Router.patternize('/cats'), Cats2Controller, :index
      get Router.patternize('/cats/:cat_id/statuses'), StatusesController, :index
    end
  end
end
