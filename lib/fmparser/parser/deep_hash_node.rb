module FMParser
  class Parser
    class DeepHashNode
      attr_accessor :is_leaf
      attr_reader :children

      def initialize
        @is_leaf  = false
        @children = {}
      end

      # @param [String] field
      # @param [DeepHashNode] n
      def push_child(field, n)
        if !field.is_a?(String)
          raise "Invalid field type: #{field.class}"
        end
        @children[field] = n
      end

      # @param [DeepHashNode] other
      # @reutrn [bool]
      def ==(other)
        is_leaf == other.is_leaf && children == other.children
      end

      def to_h
        @children.map do |field, child|
          [field, child.to_h]
        end.to_h
      end
    end
  end
end
