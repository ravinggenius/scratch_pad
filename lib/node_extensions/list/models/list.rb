class List
  include DataMapper::Resource
  include NodeExtension

  GLUE = "\n"

  attr_accessor :items

  property :id, Serial
  property :data, Text, :required => true, :lazy => false, :accessor => :protected

  before :save do
    self.data = @items.join GLUE
  end

  after :save, :set_id

  def initialize
    @items = []
  end
end
