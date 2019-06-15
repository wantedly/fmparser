module FMParser
  class Error < StandardError; end

  class ParseError < Error; end
  class InvalidPathError < ParseError; end

  class InvalidParameterError < Error; end
end
