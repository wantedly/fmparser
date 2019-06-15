require "google/protobuf"

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "test_msg.User" do
    optional :op, :enum, 1, "test_msg.Operation"
    optional :id, :int64, 2
    repeated :names, :message, 3, "test_msg.Name"
    optional :job, :message, 4, "test_msg.Job"
  end
  add_message "test_msg.Name" do
    optional :op, :enum, 1, "test_msg.Operation"
    optional :id, :int64, 2
    optional :first_name, :string, 3
    optional :middle_name, :string, 4
    optional :last_name, :string, 5
    optional :language, :string, 6
  end
  add_message "test_msg.Job" do
    optional :op, :enum, 1, "test_msg.Operation"
    optional :id, :int64, 2
    optional :company, :string, 3
  end
  add_enum "test_msg.Operation" do
    value :OPERATION_UNSPECIFIED, 0
    value :CREATE, 1
    value :UPDATE, 2
    value :DELETE, 3
  end
end

module TestMsg
  User = Google::Protobuf::DescriptorPool.generated_pool.lookup("test_msg.User").msgclass
  Name = Google::Protobuf::DescriptorPool.generated_pool.lookup("test_msg.Name").msgclass
  Job = Google::Protobuf::DescriptorPool.generated_pool.lookup("test_msg.Job").msgclass
  Operation = Google::Protobuf::DescriptorPool.generated_pool.lookup("test_msg.Operation").enummodule
end
