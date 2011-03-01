# http://railstips.org/blog/archives/2009/12/18/why-i-think-mongo-is-to-databases-what-rails-was-to-frameworks/
# http://railstips.org/blog/archives/2010/06/16/mongomapper-08-goodies-galore/

class Node
  STATES = [
    :draft,
    :published
  ]

  attr_writer :children

  include MongoMapper::Document
  include Relationship

  key :path, String
  key :filter_group_id, BSON::ObjectId, :required => true
  key :children_ids, Array, :typecast => 'BSON::ObjectId'
  key :state, String, :required => true, :default => :draft
  key :title, String, :required => true

  timestamps!
  userstamps!

  belongs_to :filter_group
  habtm :nodes, :terms, :glue_model => :tagging

  before_save :set_children_ids

  validates_uniqueness_of :path, :allow_blank => true
  validate :ensure_not_ancestor_of_self
  validate :ensure_valid_state

  def children
    (self.children_ids || []).map { |child_id| Node.find child_id }.reject &:blank?
  end

  def descendants
    (children + children.map(&:descendants)).reject &:blank?
  end

  def parse_terms(vocabularies)
    terms = []
    vocabularies.each do |vocabulary, term_ids|
      terms << term_ids.map { |term_id| Term.find term_id }
    end
    self.terms = terms.flatten
  end

  # rails router dsl uses to_param to generate urls
  # overriding to_param would not allow slashes in path
  # therefore, to_param is left alone
  def to_path
    path.to_s.blank? ? _id.to_s : path
  end

  def vocabularies
    terms.map { |term| term.vocabulary }.uniq
  end

  def self.from_path(path)
    return nil if path.blank?
    reply = first :path => path
    reply = find path rescue nil unless reply.present?
    reply
  end

  def self.title
    match_data = /^NodeExtensions::(?<ne>.*)::Model$/.match name
    match_data ? match_data[:ne] : name
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

  # TODO factor out exception handling
  def ensure_not_ancestor_of_self
    begin
      descendants
    rescue SystemStackError => e
      errors.add :parent, 'may not be its own descendant'
    end
  end

  def ensure_valid_state
    states = self.class::STATES.map &:to_s
    errors.add :state, "must be one of #{states.join ', '}" unless states.include? state.to_s
  end

  # TODO move to before_save &block
  def set_children_ids
    self.children_ids = children.map &:id
  end

  protected :children_ids, :children_ids=
end
