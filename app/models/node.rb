# http://railstips.org/blog/archives/2009/12/18/why-i-think-mongo-is-to-databases-what-rails-was-to-frameworks/
# http://railstips.org/blog/archives/2010/06/16/mongomapper-08-goodies-galore/

class Node
  include MongoMapper::Document
  extend Relationship

  key :children_ids, Array, :typecast => 'ObjectId'
  key :is_published, Boolean, :default => false
  key :name, String, :required => true
  key :position, Integer, :default => 0

  timestamps!
  userstamps!

  habtm :nodes, :terms, :tagging

  before_save :set_children_ids
  after_save :save_taggings

  def children
    self.children_ids ||= []
    @children ||= self.children_ids.map { |child_id| Node.find(child_id) }
  end

  def machine_name
    self.class.name.underscore
  end

  def self.published(published = true)
    all :is_published => published
  end

  alias :title :name
  alias :title= :name=
  alias :author :creator
  alias :author= :creator=
  alias :editor :updater
  alias :editor= :updater=

  private

  def set_children_ids
    @children ||= []
    self.children_ids = @children.map { |child| child.id }
  end

  protected :children_ids, :children_ids=
end
