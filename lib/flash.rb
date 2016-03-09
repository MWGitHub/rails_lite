class Flash
  FLASH_KEY = '_flash'

  attr_reader :now

  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(cookie)
    @cookie = cookie
    @cookie[FLASH_KEY] = {}

    @now = {}
  end

  def [](key)
    if now[key]
      now[key]
    else
      @cookie[FLASH_KEY][key]
    end
  end

  def []=(key, val)
    @cookie[FLASH_KEY][key] = val
  end

  def reset
    @cookie[FLASH_KEY] = {}
  end
end
