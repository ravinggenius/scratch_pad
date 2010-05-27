class Term
  include MongoMapper::Document

  key :name, String, :required => true

  belongs_to :vocabulary
  many :taggings

  after_save :save_taggings

  def nodes
    @nodes ||= Tagging.nodes_for(self.id)
  end

  private

  def save_taggings
    @nodes ||= []
    @nodes.each { |node| Tagging.first_or_create(:node_id => node.id, :term_id => self.id) }
  end
end
