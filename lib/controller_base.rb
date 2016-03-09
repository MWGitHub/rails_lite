class ControllerBase
  attr_reader :req, :res, :params, :already_built_response

  alias_method :already_built_response?, :already_built_response

  # Setup the controller
  def initialize(req, res, params = {})
    @req = req
    @res = res
    @params = params.merge(req.params)
    @already_built_response = false
  end

  # Set the response status code and header
  def redirect_to(url)
    if already_built_response?
      raise AlreadyBuiltResponseError.new('Response already built')
    end
    @already_built_response = true

    res.status = 302
    res['Location'] = url
    session.store_session(res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    if already_built_response?
      raise AlreadyBuiltResponseError.new('Response already built')
    end
    @already_built_response = true

    res.write(content)
    res['Content-Type'] = content_type
    session.store_session(res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    file_name = "views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
    content = ERB.new(File.read(file_name)).result(binding)
    render_content(content, 'text/html')
  end

  def session
    @session ||= Session.new(req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    send(name)
  end
end

class AlreadyBuiltResponseError < StandardError
end
