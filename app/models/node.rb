# http://railstips.org/blog/archives/2009/12/18/why-i-think-mongo-is-to-databases-what-rails-was-to-frameworks/

class Node
  include MongoMapper::Document

  key :children_ids, Array # TODO: validate proper sub-types
  key :title, String
  key :position, Integer, :default => 0

  timestamps!
  userstamps!

  many :vocabularies
  many :terms

  validates_numericality_of :position, :only_integer => true
  validates_presence_of :title, :position

  before_save :set_children_ids

  def children
    self.children_ids ||= []
    @children ||= self.children_ids.map { |child_id| Node.get(child_id) }
  end

  def machine_name
    self.class.name.underscore
  end

  private

  def set_children_ids
    @children ||= []
    self.children_ids = @children.map { |child| child.id }
  end

  protected :children_ids
end
