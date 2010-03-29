class Term
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true

  belongs_to :vocabulary
  has n, :nodes, :through => Resource
end
