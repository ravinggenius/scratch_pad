# http://railstips.org/blog/archives/2009/12/18/why-i-think-mongo-is-to-databases-what-rails-was-to-frameworks/
# http://railstips.org/blog/archives/2010/06/16/mongomapper-08-goodies-galore/

class Node
  attr_writer :children

  include MongoMapper::Document
  include Relationship

  key :filter_group_id, BSON::ObjectId, :required => true
  key :children_ids, Array, :typecast => 'BSON::ObjectId'
  key :state, String, :required => true, :default => :draft # TODO formalize states
  key :title, String, :required => true

  timestamps!
  userstamps!

  belongs_to :filter_group
  habtm :nodes, :terms, :glue_model => :tagging

  before_save :set_children_ids

  def children
    @children ||= (self.children_ids || []).map { |child_id| Node.find child_id }
  end

  def parse_terms(vocabularies)
    terms = []
    vocabularies.each do |vocabulary, term_ids|
      terms << term_ids.map { |term_id| Term.find term_id }
    end
    self.terms = terms.flatten
  end

  def vocabularies
    terms.map { |term| term.vocabulary }.uniq
  end

  def self.title
    name
  end

  def self.machine_name
    title.underscore
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

  def self.published
    all :state => :published
  end

  alias :name :title
  alias :name= :title=
  alias :author :creator
  alias :author= :creator=
  alias :editor :updater
  alias :editor= :updater=

  private

  # TODO move to before_save &block
  def set_children_ids
    self.children_ids = children.map &:id
  end

  protected :children_ids, :children_ids=
end
