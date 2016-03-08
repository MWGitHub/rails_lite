require 'json'

class Session
  APP_COOKIE = '_rails_lite_app'

  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    if req.cookies[APP_COOKIE]
      @cookie = JSON.parse(req.cookies[APP_COOKIE])
    else
      @cookie = {}
    end
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie(APP_COOKIE, @cookie.to_json)
  end
end
