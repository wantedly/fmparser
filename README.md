# FMParser

**F**ield**M**ask **Parser**. If you want to know more about FieldMask, please see https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#fieldmask .

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fmparser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fmparser

## Usage

`FMParser.parse` parses FieldMask parameter and returns a `FMParser::MessageNode` object.

For example, suppose you have the protobuf message classes shown below:

```proto
syntax = "proto3";
package msg;

message User {
  Operation op = 1;
  int64 id = 2;
  repeated Name names =3;
  Job job = 4;
}

message Name {
  Operation op = 1;
  int64 id = 2;
  string first_name = 3;
  string middle_name = 4;
  string last_name = 5;
  string language = 6;
}

message Job {
  Operation op = 1;
  int64 id = 2;
  string company = 3;
}

enum Operation {
  OPERATION_UNSPECIFIED = 0;
  CREATE = 1;
  UPDATE = 2;
  DELETE = 3;
}
```

Then, you can parse `paths` array of strings with `root` protobuf message class.

```ruby
[1] pry(main)> f = FMParser.parse(paths: ["op", "id", "names.first_name", "names.last_name"], root: Msg::User)
=> #<FMParser::MessageNode:0x00007f7fc9848168
 @enums=[#<FMParser::EnumNode:0x00007f7fc98489b0 @label=:optional, @name=:op, @type=Msg::Operation>],
 @label=nil,
 @messages=
  [#<FMParser::MessageNode:0x00007f7fc9848208
    @enums=[],
    @label=:repeated,
    @messages=[],
    @name=:names,
    @scalars=
     [#<FMParser::ScalarNode:0x00007f7fc98484b0 @label=:optional, @name=:first_name, @type=:string>,
      #<FMParser::ScalarNode:0x00007f7fc98482a8 @label=:optional, @name=:last_name, @type=:string>],
    @type=Msg::Name>],
 @name=nil,
 @scalars=[#<FMParser::ScalarNode:0x00007f7fc9848820 @label=:optional, @name=:id, @type=:int64>],
 @type=Msg::User>

[2] pry(main)> f.field_names
=> [:id, :op, :names]

[3] pry(main)> f.has?(:id)
=> true

[4] pry(main)> f.has?(:names)
=> true

[5] pry(main)> f.has?(:job)
=> false

[6] pry(main)> f.get_child(:names)
=> #<FMParser::MessageNode:0x00007f7fc9848208
 @enums=[],
 @label=:repeated,
 @messages=[],
 @name=:names,
 @scalars=
  [#<FMParser::ScalarNode:0x00007f7fc98484b0 @label=:optional, @name=:first_name, @type=:string>,
   #<FMParser::ScalarNode:0x00007f7fc98482a8 @label=:optional, @name=:last_name, @type=:string>],
 @type=Msg::Name>

[7] pry(main)> f.get_child(:names).field_names
=> [:first_name, :last_name]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/south37/fmparser.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
