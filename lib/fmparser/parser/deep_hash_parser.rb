require "fmparser/parser/deep_hash_node"

module FMParser
  class Parser
    # DeepHashParser parses paths (string array) to a deep hash.
    # ex.
    # param: ["id", "facebook_uid", "detail", "detail.id", "profile.name"]
    # return: <is_leaf: false, children: {
    #   "id" => <is_leaf: true, children: {}>,
    #   "facebook_uid" => <is_leaf: true, children: {}>,
    #   "detail" => <is_leaf: true, children: {
    #     "id" => <is_leaf: true, children: {}>
    #   }>,
    #   "profile" => <is_leaf: false, children: {
    #     "name" => <is_leaf: true, children: {}>
    #   }>
    # }>
    class DeepHashParser
      class << self
        # @param [<String>] paths
        # @return [DeepHashNode]
        def parse(paths)
          node = DeepHashNode.new
          paths.each do |path|
            deep_push!(node.children, path.split('.').map(&:strip))
          end
          node
        end

      private

        # @param [Hash] h
        # @param [<String>] field_list
        def deep_push!(h, field_list)
          if field_list.size < 1
            # Do nothing
            return
          end

          f      = field_list.first
          f_rest = field_list[1..-1]

          if !h[f]
            h[f] = DeepHashNode.new
          end
          if f_rest.size == 0
            h[f].is_leaf = true
          end

          deep_push!(h[f].children, f_rest)
        end
      end
    end
  end
end
