require "fmparser/parser"
require "fmparser/version"

module FMParser
  class << self
    # @param [<String>] paths
    # @param [Class] root Google::Protobuf message class
    def parse(paths:, root:)
      parser = Parser.new
      parser.parse(paths: paths, root: root)
    end
  end
end
