# http://railstips.org/blog/archives/2009/12/18/why-i-think-mongo-is-to-databases-what-rails-was-to-frameworks/
# http://railstips.org/blog/archives/2010/06/16/mongomapper-08-goodies-galore/

class Node
  include MongoMapper::Document
  include Relationship

  key :filter_group_id, BSON::ObjectID, :required => true
  key :children_ids, Array, :typecast => 'BSON::ObjectID' # TODO move heirarchy to separate model
  key :is_published, Boolean, :default => false
  key :title, String, :required => true
  key :position, Integer, :default => 0

  timestamps!
  userstamps!

  belongs_to :filter_group
  habtm :nodes, :terms, :glue_model => :tagging

  before_save :set_children_ids

  def children
    self.children_ids ||= []
    @children ||= self.children_ids.map { |child_id| Node.find(child_id) }
  end

  def extension
    NodeExtension[machine_name]
  end

  def machine_name
    self.class.name.underscore
  end

  def vocabularies
    terms.map { |term| term.vocabulary }.uniq
  end

  def self.model_name
    name = 'node'
    name.instance_eval do
      def plural;   pluralize;   end
      def singular; singularize; end
      def human;    singularize; end
    end
    return name
  end

  def self.published(published = true)
    all :is_published => published
  end

  alias :name :title
  alias :name= :title=
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
