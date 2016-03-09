class Cookie
  APP_COOKIE = '_rails_lite_app'

  attr_reader :cookie_key

  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req, key = APP_COOKIE)
    @cookie_key = key
    if req.cookies[cookie_key]
      @cookie = JSON.parse(req.cookies[cookie_key])
    else
      @cookie = {}
    end
  end

  def [](key)
    @cookie[key.to_s]
  end

  def []=(key, val)
    @cookie[key.to_s] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie(cookie_key, { value: @cookie.to_json, path: '/' })
  end
end
