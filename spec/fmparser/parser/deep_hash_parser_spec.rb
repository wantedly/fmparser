describe FMParser::Parser::DeepHashParser do
  # Alias
  DeepHashBuilder = FMParser::Parser::DeepHashParser

  describe ".parse" do
    it "parses paths and generates node" do
      expect(DeepHashBuilder.parse([""])).to eq node(
        is_leaf: false,
        children: {}
      )

      expect(DeepHashBuilder.parse(["id"])).to eq node(
        is_leaf: false,
        children: {
          "id" => node(
            is_leaf: true,
            children: {}
          )
        }
      )

      expect(DeepHashBuilder.parse(["id", "profile.name"])).to eq node(
        is_leaf: false,
        children: {
          "id" => node(
            is_leaf: true,
            children: {}
          ),
          "profile" => node(
            is_leaf: false,
            children: {
              "name" => node(
                is_leaf: true,
                children: {}
              )
            }
          ),
        }
      )

      expect(DeepHashBuilder.parse(["id", "profile", "profile.name"])).to eq node(
        is_leaf: false,
        children: {
          "id" => node(
            is_leaf: true,
            children: {}
          ),
          "profile" => node(
            is_leaf: true,
            children: {
              "name" => node(
                is_leaf: true,
                children: {}
              )
            }
          ),
        }
      )
    end
  end

  def node(is_leaf:, children:)
    n = FMParser::Parser::DeepHashNode.new
    n.is_leaf = is_leaf
    children.each { |field, c| n.push_child(field, c) }
    n
  end
end
