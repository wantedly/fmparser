require "fmparser/error"
require "fmparser/node"
require "fmparser/parser/deep_hash_parser"

module FMParser
  class Parser
    # @param [<String>] paths
    # @param [Class] root Google::Protobuf message class
    def parse(paths:, root:)
      deep_hash = DeepHashParser.parse(paths)

      scalars, enums, messages = build_nodes(
        descriptor: root.descriptor,
        deep_hash:  deep_hash,
      )

      MessageNode.new(
        name:     nil,
        type:     root,
        label:    nil,
        scalars:  scalars,
        enums:    enums,
        messages: messages,
      )
    end

  private

    # @param [Google::Protobuf::Descriptor] descriptor
    # @param [FMParser::Parser::DeepHashNode] deep_hash
    # @return [<<ScalarNode>, <EnumNode>, <MessageNode>>]
    def build_nodes(descriptor:, deep_hash:)
      scalars  = []
      enums    = []
      messages = []

      deep_hash.children.each do |name, dh|
        entry = descriptor.entries.find { |e| e.name == name }

        if entry.nil?
          raise InvalidPathError.new("\"#{name}\" does not exist in the fields of #{descriptor.msgclass}!")
        end

        case entry.type
        when :message
          d = entry.subtype  # Google::Protobuf::Descriptor
          s, e, m = build_nodes(
            descriptor: d,
            deep_hash:  dh,
          )
          n = MessageNode.new(
            name:     name,
            type:     d.msgclass,
            label:    entry.label,
            scalars:  s,
            enums:    e,
            messages: m,
          )
          messages << n
        when :enum
          # NOTE: If dh.is_leaf is false, it is invalid. But ignore it now.
          d = entry.subtype  # Google::Protobuf::EnumDescriptor
          n = EnumNode.new(name: name, type: d.enummodule, label: entry.label)
          enums << n
        else  # We treat this case as scalar
          # NOTE: If dh.is_leaf is false, it is invalid. But ignore it now.
          n = ScalarNode.new(name: name, type: entry.type, label: entry.label)
          scalars << n
        end
      end

      [
        scalars,
        enums,
        messages,
      ]
    end
  end
end
