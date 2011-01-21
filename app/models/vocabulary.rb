class Vocabulary
  include MongoMapper::Document

  key :stub, String, :required => true, :unique => true
  key :name, String, :required => true, :unique => true
  key :is_freetaggable, Boolean, :required => true, :default => false
  key :is_hierarchical, Boolean, :required => true, :default => false
  key :is_multiselectable, Boolean, :required => true, :default => true
  key :node_types_optional, NodeExtensionArray, :required => true
  key :node_types_required, NodeExtensionArray, :required => true

  many :terms

  before_save do |vocabulary|
    vocabulary.node_types_optional = vocabulary.node_types_optional - vocabulary.node_types_required
  end

  def to_param
    stub
  end

  def self.from_param(stub)
    first :stub => stub
  end
end
