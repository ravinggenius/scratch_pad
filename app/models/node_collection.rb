class NodeCollection
  include DataMapper::Resource
  include NodeExtension

  property :id, Serial
  property :discriminator, Discriminator, :required => true
  property :node_ids, CommaSeparatedList, :accessor => :protected

  # validate proper sub-types

  before :save do
    @nodes ||= []
    self.node_ids = @nodes.map do |n|
      n = n.node if n.respond_to? :node
      n.id
    end
  end

  after :save, :set_id

  def nodes
    self.node_ids ||= []
    @nodes ||= self.node_ids.map { |node_id| Node.get(node_id.to_i).extension }
  end
end
