class ControllerBase
  attr_reader :req, :res, :params, :already_built_response

  alias_method :already_built_response?, :already_built_response

  # Setup the controller
  def initialize(req, res, params = {})
    @req = req
    @res = res
    @params = params.merge(req.params)
    @already_built_response = false
    @has_rendered_base = false
  end

  # Set the response status code and header
  def redirect_to(url)
    prepare_built_response

    res.status = 302
    res['Location'] = url
    store_cookies
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    prepare_built_response

    res.write(content)
    res['Content-Type'] = content_type
    store_cookies
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    if already_built_response?
      raise AlreadyBuiltResponseError.new('Response already built')
    end

    file = find_template_file(template_name)
    unless @has_rendered_base
      @has_rendered_base = true
      content = render('layouts/application.html.erb') do
        render(template_name)
      end
      render_content(content, 'text/html')
    else
      ERB.new(file).result(binding)
    end
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(session)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    send(name)
  end

  private
  def find_template_file(name)
    name = name.to_s
    class_dir = "app/views/#{self.class.to_s.underscore}/"

    # Check if controller finds template
    shortcut_file = "#{class_dir}#{name}.html.erb"
    if File.exist?(shortcut_file)
      return File.read(shortcut_file)
    end

    # Convert the file name to partial format
    partial_name = name.split('/')
    partial_name[-1] = "_#{partial_name[-1]}.html.erb"
    partial_name = partial_name.join('/')

    # Check if partial exists in controller views
    class_file_name = "#{class_dir}#{partial_name}"
    if File.exist?(class_file_name)
      return File.read(class_file_name)
    end

    # Check if partial exists in base views
    base_file_name = "app/views/#{partial_name}"
    if File.exists?(base_file_name)
      return file = File.read(base_file_name)
    end

    # Search for the file directly as a string
    file = File.read("app/views/#{name}")
  end

  def prepare_built_response
    if already_built_response?
      raise AlreadyBuiltResponseError.new('Response already built')
    end
    @already_built_response = true
  end

  def store_cookies
    session.store_session(res)
  end
end

class AlreadyBuiltResponseError < StandardError
end
