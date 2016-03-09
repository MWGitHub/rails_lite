class Flash
  FLASH_KEY = '_flash'

  attr_reader :now

  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(cookie)
    @cookie = cookie

    @now = cookie[FLASH_KEY] || {}

    reset
  end

  def [](key)
    if now[key.to_s]
      now[key.to_s]
    else
      @cookie[FLASH_KEY][key.to_s]
    end
  end

  def []=(key, val)
    @cookie[FLASH_KEY][key.to_s] = val
  end

  private
  def reset
    @cookie[FLASH_KEY] = {}
  end
end
