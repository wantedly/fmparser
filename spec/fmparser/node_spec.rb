require "support/test_msg"

describe FMParser::Node do
end

describe FMParser::MessageNode do
  describe "#fields and #field_names" do
    let!(:scalar) {
      FMParser::ScalarNode.new(
        name:  :id,
        type:  :int64,
        label: :optional,
      )
    }
    let!(:enum) {
      FMParser::EnumNode.new(
        name:  :op,
        type:  TestMsg::Operation,
        label: :optional,
      )
    }
    let(:message) {
      FMParser::MessageNode.new(
        name:     :names,
        type:     TestMsg::Name,
        label:    :repeated,
        scalars:  [],
        enums:    [],
        messages: [],
      )
    }

    it "returns all field nodes" do
      n = FMParser::MessageNode.new(
        name:     nil,
        type:     TestMsg::User,
        label:    nil,
        scalars:  [scalar],
        enums:    [enum],
        messages: [message],
      )
      expect(n.fields).to contain_exactly(scalar, enum, message)
      expect(n.field_names).to contain_exactly(:id, :op, :names)
    end
  end

  describe "#has?" do
    let(:node) {
      FMParser::MessageNode.new(
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
        enums:    [],
        messages: [],
      )
    }

    context "when field is included" do
      it "returns true" do
        expect(node.has?(:id)).to eq true
      end
    end

    context "when field is not included" do
      it "returns true" do
        expect(node.has?(:op)).to eq false
        expect(node.has?(:names)).to eq false
      end
    end

    context "when field is invalid" do
      it "raises InvalidFieldError" do
        expect { node.has?(:invalid_field) }.to raise_error(FMParser::InvalidParameterError)
      end
    end
  end

  describe "#get_child" do
    let(:node) {
      FMParser::MessageNode.new(
        name:     nil,
        type:     TestMsg::User,
        label:    nil,
        scalars:  [],
        enums:    [],
        messages: [names_node],
      )
    }
    let(:names_node) {
      FMParser::MessageNode.new(
        name:     :names,
        type:     TestMsg::Name,
        label:    :repeated,
        scalars:  [],
        enums:    [],
        messages: [],
      )
    }

    context "when field is included" do
      it "returns child" do
        expect(node.get_child(:names)).to eq names_node
      end
    end

    context "when field is not included" do
      it "returns nil" do
        expect(node.get_child(:job)).to eq nil
      end
    end

    context "when field is invalid" do
      it "raises InvalidFieldError" do
        expect { node.get_child(:invalid_field) }.to raise_error(FMParser::InvalidParameterError)
      end
    end
  end
end
