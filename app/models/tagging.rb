class Tagging
  include MongoMapper::Document

  key :node_id, String, :required => true
  key :term_id, String, :required => true

  def node
    @node ||= Node.find(node_id)
  end

  def term
    @term ||= Term.find(term_id)
  end

  def node=(new_node)
    self.node_id = new_node.id
    @node = new_node
  end

  def term=(new_term)
    self.term_id = new_term.id
    @term = new_term
  end

  def self.nodes_for(term_id)
    all(:term_id => term_id.to_s).map { |tagging| tagging.node }
  end

  def self.terms_for(node_id)
    all(:node_id => node_id.to_s).map { |tagging| tagging.term }
  end
end
