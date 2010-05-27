# http://railstips.org/blog/archives/2009/12/18/why-i-think-mongo-is-to-databases-what-rails-was-to-frameworks/

class Node
  include MongoMapper::Document

  key :children_ids, Array # TODO validate proper sub-types
  key :is_published, Boolean, :default => false
  key :name, String
  key :position, Integer, :default => 0

  timestamps!
  userstamps!

  validates_numericality_of :position, :only_integer => true
  validates_presence_of :name, :position

  before_save :set_children_ids
  after_save :save_taggings

  def children
    self.children_ids ||= []
    @children ||= self.children_ids.map { |child_id| Node.get(child_id) }
  end

  def terms
    @terms ||= Tagging.terms_for(self.id)
  end

  def machine_name
    self.class.name.underscore
  end

  def self.parents
    all :children_ids => []
  end

  def self.published(published = true)
    all :is_published => published
  end

  alias :title :name
  alias :title= :name=

  private

  def save_taggings
    @terms ||= []
    @terms.each { |term| Tagging.first_or_create(:node_id => self.id, :term_id => term.id) }
  end

  def set_children_ids
    @children ||= []
    self.children_ids = @children.map { |child| child.id }
  end

  protected :children_ids
end
