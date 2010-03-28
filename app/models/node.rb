require 'dm-is-list'
require 'dm-is-nested_set'
require 'dm-timestamps'

class Node
  include DataMapper::Resource

  property :id, Serial
  property :title, String, :required => true
  property :type_id, Integer, :required => true
  property :type_name, String, :required => true
  property :created_at, DateTime
  property :updated_at, DateTime

  #belongs_to :user
  #has n, :vocabularies, :through => Resource
  #has n, :terms, :through => Resource

  is :list
  #is :tree

  def extension
    @extension ||= Kernel.const_get(type_name).get(type_id)
  end
end

module NodeExtension
  def node
    @node ||= Node.first node_params
    @node ||= Node.new node_params
  end

  def method_missing missing_method, *args
    if node.respond_to? missing_method
      node.send missing_method, *args
    else
      super
    end
  end

  private

  def node_params
    { :type_id => self.id, :type_name => self.class.name }
  end

  def set_id
    node.type_id = self.id
    node.save
  end
end

class Collection
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
    @nodes ||= self.node_ids.map { |node_id| Node.get node_id.to_i }
  end
end
