Factory.define(:node) do |n|
  n.title 'Test Node'
  n.filter_group { Factory.build(:filter_group) }
end

Factory.define(:another_node, :parent => :node) do |n|
  n.title 'Another Node'
end
