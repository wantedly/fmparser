module FMParser
  class Node
  end

  class ScalarNode < Node
    # @param [String | Symbol] name
    # @param [String | Symbol] type represents the scalar type of protobuf
    # @param [String | Symbol] label
    def initialize(name:, type:, label:)
      @name  = name.to_sym
      @type  = type.to_sym
      @label = label.to_sym
    end

    attr_reader :name, :type, :label

    def ==(other)
      self.class == other.class &&
        self.name == other.name &&
        self.type == other.type &&
        self.label == other.label
    end
  end

  class EnumNode < Node
    # @param [String | Symbol] name
    # @param [Module] type represents the enum type of protobuf
    # @param [String | Symbol] label
    def initialize(name:, type:, label:)
      @name  = name.to_sym
      @type  = type
      @label = label.to_sym
    end

    attr_reader :name, :type, :label

    def ==(other)
      self.class == other.class &&
        self.name == other.name &&
        self.type == other.type &&
        self.label == other.label
    end
  end

  class MessageNode < Node
    # @param [String | Symbol | nil] name
    # @param [Class] type represents the message type of protobuf
    # @param [String | Symbol | nil] label
    def initialize(name:, type:, label:, scalars: [], enums: [], messages: [])
      @name  = name ? name.to_sym : name
      @type  = type
      @label = label ? label.to_sym : label

      @scalars  = scalars
      @enums    = enums
      @messages = messages
    end

    attr_reader :name, :type, :label, :scalars, :enums, :messages

    # @return [<FMParser::Node>]
    def fields
      scalars + enums + messages
    end

    # @return [<Symbol>]
    def field_names
      fields.map(&:name)
    end

    # @param [String | Symbol] field
    # @return [Boolean]
    def has?(field)
      f = field.to_sym
      validate!(f)
      field_names.include?(f)
    end

    # @param [String | Symbol] field
    # @return [FMParser::MessageNode | nil]
    def get_child(field)
      f = field.to_sym
      validate!(f)
      children[f]
    end

    def children
      @children ||=
        @messages.map { |m| [m.name, m] }.to_h
    end

    def ==(other)
      self.class == other.class &&
        self.name == other.name &&
        self.type == other.type &&
        self.label == other.label &&
        self.scalars == other.scalars &&
        self.enums == other.enums &&
        self.messages == other.messages
    end

  private

    # @param [Symbol]
    # @raise [InvalidFieldError]
    def validate!(field)
      if !valid_fields.include?(field)
        raise InvalidParameterError.new("There is no \"#{field}\" field in the #{@type} class")
      end
    end

    # @return [<Symbol>]
    def valid_fields
      @valid_fields ||=
        @type.descriptor.entries.map(&:name).map(&:to_sym)
    end
  end
end
