module LAME

  class LAMEError < StandardError; end

  class ConfigurationError < LAMEError; end

  class Mp3DataHeaderNotFoundError < LAMEError; end

end
