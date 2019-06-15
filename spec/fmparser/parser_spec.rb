require "support/test_msg"

describe FMParser::Parser do
  describe "#parse" do
    subject { parser.parse(paths: paths, root: root) }
    let!(:parser) {
      FMParser::Parser.new
    }

    context "when paths are blank array" do
      let(:paths) { [] }
      let(:root) { TestMsg::User }

      it "returns blank result" do
        expect(subject).to eq FMParser::MessageNode.new(
          name:     nil,
          type:     TestMsg::User,
          label:    nil,
          scalars:  [],
          enums:    [],
          messages: [],
        )
      end
    end

    context "when paths have a scalar value" do
      let(:paths) { ["id"] }
      let(:root) { TestMsg::User }

      it "returns a message node with scalar nodes" do
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
          enums:    [],
          messages: [],
        )
      end
    end

    context "when paths have a enum value" do
      let(:paths) { ["op"] }
      let(:root) { TestMsg::User }

      it "returns a message node with enum nodes" do
        expect(subject).to eq FMParser::MessageNode.new(
          name:     nil,
          type:     TestMsg::User,
          label:    nil,
          scalars:  [],
          enums:    [
            FMParser::EnumNode.new(
              name:  :op,
              type:  TestMsg::Operation,
              label: :optional,
            )
          ],
          messages: [],
        )
      end
    end

    context "when paths have message values" do
      let(:paths) { ["names.first_name", "names.last_name"] }
      let(:root) { TestMsg::User }

      it "returns a message node with child message nodes" do
        expect(subject).to eq FMParser::MessageNode.new(
          name:     nil,
          type:     TestMsg::User,
          label:    nil,
          scalars:  [],
          enums:    [],
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

    context "when paths have a message value without fields" do
      let(:paths) { ["names"] }
      let(:root) { TestMsg::User }

      it "returns a message node with a child message node which has no field" do
        expect(subject).to eq FMParser::MessageNode.new(
          name:     nil,
          type:     TestMsg::User,
          label:    nil,
          scalars:  [],
          enums:    [],
          messages: [
            FMParser::MessageNode.new(
              name:     :names,
              type:     TestMsg::Name,
              label:    :repeated,
              scalars:  [],
              enums:    [],
              messages: [],
            )
          ],
        )
      end
    end

    context "when paths have a word which is not in the fields of message class" do
      let(:paths) { ["invalid_field"] }
      let(:root) { TestMsg::User }

      it "raises an InvalidPathError" do
        expect { subject }.to raise_error(FMParser::InvalidPathError)
      end
    end
  end
end
