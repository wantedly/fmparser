require "support/test_msg"

describe FMParser do
  describe ".parse" do
    subject { FMParser.parse(paths: paths, root: root) }

    let(:paths) { ["id", "op", "names.first_name", "names.last_name"] }
    let(:root) { TestMsg::User }

    it "parses paths and returns a message node" do
      expect(subject).to eq FMParser::MessageNode.new(
        name:     nil,
        type:     TestMsg::User,
        label:    nil,
        scalars:  [
          FMParser::ScalarNode.new(
            name:  :id,
            type:  :int64,
            label: :optional,
          )
        ],
        enums:    [
          FMParser::EnumNode.new(
            name:  :op,
            type:  TestMsg::Operation,
            label: :optional,
          )
        ],
        messages: [
          FMParser::MessageNode.new(
            name:     :names,
            type:     TestMsg::Name,
            label:    :repeated,
            scalars:  [
              FMParser::ScalarNode.new(
                name:  :first_name,
                type:  :string,
                label: :optional,
              ),
              FMParser::ScalarNode.new(
                name:  :last_name,
                type:  :string,
                label: :optional,
              )
            ],
            enums:    [],
            messages: [],
          )
        ],
      )
    end
  end
end
